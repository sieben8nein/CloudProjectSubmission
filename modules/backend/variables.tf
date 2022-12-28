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


variable "project" {}
variable "subnet" {}
variable "connector_ids" {}
variable "ports" {
  type = object({
    name = string
    port = number
  })
  description = "Port which the container listens to (http1 or h2c)"
  default = {
    name = "http1"
    port = 3000
  }
}

variable "name" {
  description = "Name of the service"
}
variable "env"{

}

# variable "env_vars" {
#   type = list(object({
#     value = string
#     name  = string
#   }))
#   description = "Environment variables (cleartext)"
#   default     = [
#     {name="MONGO_DB_NAME", value="CloudProjectDB"},
#     {name="REDIS_URI", value="10.81.87.163:6379"},
#     {name="NODE_ENV", value="dev"}
# ]
# }

# variable "env_secret_vars" {
#   type = list(object({
#     name = string
#     value_from = set(object({
#       secret_key_ref = map(string)
#     }))
#   }))
#   description = "[Beta] Environment variables (Secret Manager)"
#   default     = [{name="MONGO_DB_CONNECTION_STRING", key="2"} ]
# }