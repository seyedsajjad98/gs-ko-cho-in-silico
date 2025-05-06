# Install packages (run only once)
install.packages("readxl")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("ggrepel")

# Load the packages
library(readxl)
library(dplyr)
library(ggplot2)
library(ggrepel)


guides <- read_excel(
  "guides_GS_GCF_003668045.3-NC_048598.1-37805741-37805908.xls",
  skip = 8
)


# Check the first few rows to ensure it loaded correctly
head(guides)





# 1) Make names R-friendly
names(guides) <- make.names(names(guides))

# 2) Convert the three key scores (and offtargetCount) to numeric
guides <- guides %>%
  mutate(
    Doench.16.Score      = as.numeric(Doench..16.Score),
    cfdSpecScore         = as.numeric(cfdSpecScore),
    Out.of.Frame.Score   = as.numeric(Out.of.Frame.Score),
    offtargetCount       = as.integer(offtargetCount)
  )



final.guides <- guides %>%
  filter(
    Doench.16.Score    >= 60,   # good cutting
    cfdSpecScore       >= 70,   # low off-target risk
    Out.of.Frame.Score >= 50    # good KO probability
  ) %>%
  arrange(desc(Out.of.Frame.Score), desc(cfdSpecScore))
final.guides


ggplot(guides, aes(x = Doench.16.Score, y = cfdSpecScore)) +
  geom_point(aes(color = Out.of.Frame.Score, size = offtargetCount), alpha = .7) +
  scale_color_viridis_c(name = "Out-of-Frame\nScore") +
  scale_size_continuous(name = "Off-target\nCount") +
  geom_text_repel(data = final.guides,
                  aes(label = X.guideId),
                  size = 3) +
  labs(
    title = "Guide Efficiency vs Specificity",
    subtitle = "color = frameshift probability, size = raw off-target count",
    x = "Doench ’16 Efficiency",
    y = "CFD Specificity"
  ) +
  theme_minimal()



ggplot(final.guides, aes(x = reorder(X.guideId, -offtargetCount), y = offtargetCount)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Off-target Count for Top Candidates",
    x = "Guide ID",
    y = "Total Predicted Off-targets"
  ) +
  theme_minimal()






