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
  network = "${element(split("-", var.subnet), 0)}"
}

resource "google_cloud_run_service" "default" {
  provider = google-beta
  name     = var.name
  location = "europe-west3"


  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = 10
        "run.googleapis.com/client-name" = "terraform"
        "autoscaling.knative.dev/minScale" = 1
        "run.googleapis.com/vpc-access-connector" = element(tolist(var.connector_ids), 1)
        "run.googleapis.com/vpc-access-egress"    = "private-ranges-only"
      }
    }
    spec {
      containers {
        image = "europe-west3-docker.pkg.dev/cloudproject-364711/cloud-project/${var.env}-frontend:latest"
        # expose port - ref variables
        ports {
          container_port = 80
        }

        # find env variables
        env {
          name = "BACKEND_URL"
          value = "${var.backend}:3000"
        }
      }
    }
  }


  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}


