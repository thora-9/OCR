#Tips:
#1) Watch out for the stamps OMVS puts on the documents. It messes up the OCR. Work around is to use MS Paint to crop out the stamp
#2) The edges of every page can contain tons of noise which the OCR tries to recognize. Line 37:44 tries to reduce that by cropping the edges.
#3) Make sure the cropping in step 1 is not too close to the target region
#4) Try putting all the tables and figures at the end of the document if possible

library(tesseract)
library(magick)
library(xml2)
library(stringr)
library(tibble)
library(pdftools)
library(gtools)

#Here we create names for the tiff files that get generated
naam=seq(11,278,by=1)
naam=as.character(naam)
naam2=sapply(naam, function (x) paste(x,'.tiff',sep=""))

pdf_convert('OMVS_14349.pdf', format = "tiff",pages = NULL,filenames = naam2, dpi = 300)
#pdf_convert('OMVS_9530.pdf', format = "tiff",pages = 16,filenames = 'tp.tiff', dpi = 300)


myfiles <- list.files(pattern = "tiff",  full.names = FALSE)
myfiles<-mixedsort(myfiles)
#myfiles <-sort(myfiles2)
out=NULL
i=10

for (i in 1:20){ #length(myfiles)

test=image_read(myfiles[i],strip = TRUE)

image_bearb1 <- test %>%
  #image_scale("x2000") %>%                        # rescale
  image_background("white", flatten = TRUE) %>%   # set background to white
  #image_trim() %>%                                # Trim edges that are the background color from the image.
  image_noise() %>%                               # Reduce noise in image using a noise peak elimination filter
  image_enhance() %>%                             # Enhance image (minimize noise)
  image_normalize() %>%                           # Normalize image (increase contrast by normalizing the pixel values to span the full range of color values).
  image_contrast(sharpen = 1)# %>%                 # increase contrast
#image_deskew(treshold = 40)                     # deskew image -> creates negative offset in some scans

#image_browse(image_bearb1)

#Crop out the edges of the document using a certain percent of the width and height of OG doc
dim_im=image_info(image_bearb1)

cr_edges=paste((0.98*dim_im[2]),'x',0.92*dim_im[3],"+",0.05*dim_im[2],'+',0.04*dim_im[3],sep="")

tess_input=image_crop(image_bearb1,cr_edges)

#print(tess_input)

#image_write(image_bearb1,'new.png', format = "png")
#tess_input=image_bearb1

#whitelist <- "1234567890-.,;:qwertyuiopasdfghjklz\xcvbnm,./\';][QWERTYUIOPASDFGHJKLZXCVBNM!$%&/()=?+ùûüÿ€’“”«  »–à—âæçéèêëïîôœÙÛÜŸ€’“”«  »–—ÀÂÆÇÉÈËÏÎÔŒ"

text1 <- ocr(tess_input,
             engine = tesseract(language = "eng+fra")
             ,HOCR = FALSE) #options = list(tessedit_char_whitelist = whitelist)

out=paste(out,text1,sep=' ')
print(i)
}


write(out,'OMVS_14349_test_v2.txt')

#Tips:
#1) Watch out for the stamps OMVS puts on the documents. It messes up the OCR. Work around is to use MS Paint to crop out the stamp
#2) The edges of every page can contain tons of noise which the OCR tries to recognize. Line 37:44 tries to reduce that by cropping the edges.
#3) Make sure the cropping in step 1 is not too close to the target region
#3) Try putting all the tables and figures at the end of the document if possible


