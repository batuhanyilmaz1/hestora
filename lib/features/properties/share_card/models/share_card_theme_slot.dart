/// Named regions mapped onto a fixed background template.
enum ShareCardThemeSlot {
  mainImage,
  /// Optional extra listing photos: [ShareCardLayoutData] index 1…3.
  galleryImage1,
  galleryImage2,
  galleryImage3,
  title,
  price,
  features,
  location,
  listingType,
  agentName,
  agentPhone,
  /// QR when [ShareCardLayoutData.qrPayload] is non-empty; otherwise website text.
  websiteOrQr,
  logo,
}
