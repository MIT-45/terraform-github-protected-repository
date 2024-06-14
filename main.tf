
# create repository
resource "github_repository" "repo" {
  name = var.name
  description = var.description
  visibility = "private"
  auto_init = true
  github_branch_default  = "main"
  archive_on_destroy = true
}

# create branch main
resource "github_branch" "main" {
  branch     = "main"
  repository = github_repository.repo
}

# make main default branch
resource "github_branch_default" "default" {
  branch     = github_branch.main.branch
  repository = github_repository.repo.name
}

# give teams maintain access to repository
resource "github_team_repository" "team_maintain" {
  for_each = var.teams
  repository = github_repository.repo.name
  team_id    = each.value
  permission = "maintain"
}

# give admin_teams admin access to repository
resource "github_team_repository" "admin_team" {
  for_each = var.admin_teams
  repository = github_repository.repo.name
  team_id    = each.value
  permission = "admin"
}

resource "github_repository_collaborator" "admin_user" {
  for_each = var.admin_users
  repository = github_repository.repo.name
  username    = each.value
  permission = "admin"
}

resource "github_repository_ruleset" "repo_main" {
  name = "${github_repository.repo.name}-main-protection"
  repository = github_repository.repo.name
  target = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      exclude = []
      include = [
        github_branch_default.default.branch,
      ]
    }
  }

  # org admin can bypass
  bypass_actors {
    actor_id    = 1
    actor_type  = "OrganizationAdmin"
    bypass_mode = "always"
  }

  # maintainer role need pr to bypass
  bypass_actors {
    actor_id    = 2
    actor_type  = "RepositoryRole"
    bypass_mode = "pull_request"
  }

  # admin role can bypass
  bypass_actors {
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  rules {
    # restrict deletion
    deletion = true
    # restrict update
    update = true

    pull_request {
      required_approving_review_count = 1
      required_review_thread_resolution = true
    }
  }
}
