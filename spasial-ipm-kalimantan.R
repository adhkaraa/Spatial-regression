library(readxl)       #membaca file excel
#install.packages('rgdal')        #membaca file shp, fs readOGR
library(raster)       #eksplorasi data
library(spdep)        #pembobot spasial (fungsi poly2nb)
library(lmtest)       #regresi klasik
library(nortest)      #uji kenormalan galat
library(DescTools)    #uji kebebasan galat
library(spatialreg)   #model SAR
library(RColorBrewer) #memberi warna peta
library(car)          #uji multikolinieritas
library(GWmodel)      #GWR Jarak Spasial
library(sf)
library(sp)
library(ggplot2)
library(corrplot)
library(reshape2)

setwd("D:/Kuliah/CHAPTER 6/Staitsika Spasial/Project")
df=read_excel('Data Senin Ceria.xlsx')
#df_data=read_excel('eda.xlsx')
df2 = df[-27,]
#df_data=df_data[,-4]
#df_data
View(df2)
#View(df_data)
str(df)

#data spasial
myshp=choose.files("D:/Kuliah/CHAPTER 6/Staitsika Spasial/Project/baru/kalimantan_2.shp")
data=st_read(myshp)
data2 = data[-27,]
windows()
plot(data)


#data$x = df$Longitude
#data$y=df$Latitude
#dats=st_read("D:/Kuliah/CHAPTER 6/Staitsika Spasial/Project/shp/kalimantan.shp")


#EDA
pallete=colorRampPalette(c('red','yellow','green'))
color=pallete(16)
data2$IPM=df2$IPM
# Konversi objek sf menjadi data frame
sf_df <- st_as_sf(data2) %>% st_as_sf()
# Buat plot menggunakan ggplot2
windows()
ggplot() +
  geom_sf(data = sf_df, aes(fill = IPM)) +
  scale_fill_gradientn(colors = color, na.value = "transparent") +
  labs(fill = "IPM")

#Heatmat korelasi 
windows()
cor_matrix <- cor(df_data)
melted_cor_matrix <- melt(cor_matrix)
# Membuat heatmap dengan ggplot2
ggplot(data = melted_cor_matrix, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 10, hjust = 1)) +
  coord_fixed() +
  geom_text(aes(label = round(value, 2)), color = "black", size = 4)

#Summary data
summary(df_data)


# Uji indeks moran dan buat pembobot
sf_use_s2(FALSE)
w <- poly2nb(data2)
data2$IPM=df2$IPM
ww <- nb2listw(w, zero.policy = FALSE) #kabupaten yang tidak ada tetangganya
moran(data2$IPM, ww, n=length(ww$neighbours), S0=Szero(ww))

#Uji kenormalan galat SAR
moran.test(data2$IPM, ww)
windows()
moran.plot(data2$IPM, ww, labels=data2$KAB_KOTA)

#Uji SPASIAL
#Regresi berganda klasik
reg.klasik <- lm(IPM~X1+X4+X5+X7, data = df2)
summary(reg.klasik)
aictab(cand.set = reg.klasik, modnames = mod.names)
err.regklasik <- residuals(reg.klasik)
ad.test(err.regklasik) #(normal)
#Uji kehomogenan SAR
bptest(reg.klasik) #(homogen)
#Kebebasan galat
RunsTest(err.regklasik) #galat model saling bebas
#moran index SEM
moran.test(err.regklasik, ww, randomisation=T, alternative="greater") #terdapat autokorelasi positif
#reg.klasik <- lm(TPAK ~ UMR+Jumlah_penduduk+TPT+RLS, data = df)

#Uji Efek
LM <- lm.RStests(reg.klasik, nb2listw(w, style="W"),test=c("LMerr", "LMlag","RLMerr","RLMlag","SARMA"), zero.policy=TRUE)
summary(LM)

#Uji Efek SAR
sar <- lagsarlm(IPM~X1+X4+X5+X7, data=df2, nb2listw(w))
summary(sar)
#Uji asumsi residual normalitas
err.sar<-residuals(sar)
#uji kenormalan
ad.test(err.sar)
#uji kehomogenan ragam
bptest.Sarlm(sar)
#autokorelasi
moran.test(err.sar, ww,randomisation=T, alternative="greater")

#Uji efek SEM
sem <- errorsarlm(IPM~X1+X5+X4+X7,data=df2,nb2listw(w))
summary(sem)
#residaul
err.sem<-residuals(sem)
#uji kenormalan galat
ad.test(err.sem)
#uji kehomogenan ragam galat
bptest.Sarlm(sem)
#uji autokorelasi
moran.test(err.sem,ww,randomisation=T, alternative="greater")

#Uji Efek SARMA
gsm <-sacsarlm(IPM~X1+X4+X5+X7,data=df2,nb2listw(w))
summary(gsm)
#Residual
err.gsm<-residuals(gsm)
#uji kenormalan galat
ad.test(err.gsm)
#uji kehomogenan ragam galat
bptest.Sarlm(gsm)
#uji autokorelasi
moran.test(err.gsm,ww,randomisation=T, alternative="greater")
