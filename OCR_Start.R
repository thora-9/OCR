library(tesseract)
library(magick)
library(xml2)
library(stringr)
library(tibble)

eng <- tesseract("eng")
text <- tesseract::ocr("http://jeroen.github.io/images/testocr.png", engine = eng)
cat(text)

results <- tesseract::ocr_data("http://jeroen.github.io/images/testocr.png", engine = eng)
print(results, n = 20)

tesseract_info()
tesseract_download("fra")

(french <- tesseract("fra"))

tesseract_params('colour')


frink <- image_read("https://jeroen.github.io/images/frink.png")

obama <- image_read('https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/President_Barack_Obama.jpg/800px-President_Barack_Obama.jpg')

image_charcoal(obama) %>% 
  image_composite(frink)  %>%
  image_annotate("CONFIDENTIAL", size = 50, color = "red", boxcolor = "pink",
                 degrees = 30, location = "+100+100") %>%
  image_rotate(30) %>%
  image_write('obama_with_frink.png','png')

test=image_read("test.tif",strip = TRUE)

image_bearb1 <- test %>%
  image_scale("x2000") %>%                        # rescale
  image_background("white", flatten = TRUE) %>%   # set background to white
  image_trim() %>%                                # Trim edges that are the background color from the image.
  image_noise() %>%                               # Reduce noise in image using a noise peak elimination filter
  image_enhance() %>%                             # Enhance image (minimize noise)
  image_normalize() %>%                           # Normalize image (increase contrast by normalizing the pixel values to span the full range of color values).
  image_contrast(sharpen = 1) %>%                 # increase contrast
  #image_deskew(treshold = 40)                     # deskew image -> creates negative offset in some scans

  image_browse(image_bearb1)  
  
image_write(image_bearb1,'new.png', format = "png")

#whitelist <- "1234567890-.,;:qwertzuiopüasdfghjklöäyxcvbnmQWERTZUIOPÜASDFGHJKLÖÄYXCVBNM@ß€!$%&/()=?+"

text1 <- ocr("new.png",
             engine = tesseract(language = "eng+fra"
                                ),HOCR = TRUE)
cat(text1)

image_bearb1

doc <- read_html(text1)

#detach(package:tesseract)
