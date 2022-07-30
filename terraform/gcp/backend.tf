terraform {
  backend "gcs" {
    # change this to your bucket name
    bucket = "ymtdzzz-terraform"
    prefix = "emojivoto-opentelemetry-sample"
  }
}
