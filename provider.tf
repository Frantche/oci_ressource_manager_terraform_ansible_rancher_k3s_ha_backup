terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.3"
    }
  }
}

provider "oci" {

}

provider "tls" {
  # Configuration options
}