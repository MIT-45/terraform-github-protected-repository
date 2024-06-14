
variable "name" {
  type = string
  description = "The name of the repository."
}

variable "description" {
  type = string
  description = "A description of the repository."
  nullable = true
}

variable "teams" {
  type = list(string)
  description = "teams with maintain access"
  default = []
}
variable "admin_teams" {
  type = list(string)
  description = "teams with admin access"
  default = []
}

variable "admin_users" {
  type = list(string)
  description = "users with admin access"
  default = []
}

# available gitignore templates from https://github.com/github/gitignore
variable "gitignore_template" {
  type = string
  description = ""
  nullable = true
  default = null
  validation {
    condition = var.gitignore_template == null || contains([
      "AL",
      "Actionscript",
      "Android",
      "Autotools",
      "C++",
      "C",
      "CFWheels",
      "CMake",
      "Composer",
      "GitHubPages",
      "Go",
      "Godot",
      "Haskell",
      "Laravel",
      "Magento",
      "Node",
      "Python",
      "Sass",
      "Scala",
      "Scheme",
      "Swift",
      "Symfony",
      "Terraform",
      "Unity",
      "WordPress",
      "ZendFramework",
    ], var.gitignore_template)
    error_message = "The gitignore_template must be from https://github.com/github/gitignore"
  }
}
