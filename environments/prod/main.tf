# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


locals {
  env = "prod"
}

provider "google" {
  project = "${var.project}"
}

provider "google-beta" {
  project = "${var.project}"
}

module "vpc" {
  source  = "../../modules/vpc"
  project = "${var.project}"
  env     = "${local.env}"
}
# comment
module "vpc_serverless" {
  source  = "../../modules/vpc_serverless"
  project = "${var.project}"
  env     = "${local.env}"
  subnet  = "${module.vpc.subnet}"
}


module "backend" {
  source  = "../../modules/backend"
  project = "${var.project}"
  subnet  = "${module.vpc.subnet}"
  connector_ids = "${module.vpc_serverless.connector_ids}"
  name   = "prod-backend"
  env     = "${local.env}"
}

module "frontend" {
  source  = "../../modules/frontend"
  project = "${var.project}"
  subnet  = "${module.vpc.subnet}"
  connector_ids = "${module.vpc_serverless.connector_ids}"
  name   = "prod-frontend"
  env     = "${local.env}"
  backend = "https://prod-backend-bosoxqkm5q-ey.a.run.app"
}

module "firewall" {
  source  = "../../modules/firewall"
  project = "${var.project}"
  subnet  = "${module.vpc.subnet}"
}
