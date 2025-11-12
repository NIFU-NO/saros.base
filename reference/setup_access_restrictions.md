# Setup files needed for basic password-based access restriction for website

Create a \_headers file for 'Netlify' publishing or a set of .htaccess
and .htpasswd files (FTP) placed in the specific subfolders.

## Usage

``` r
setup_access_restrictions(
  remote_basepath = "/home/",
  local_basepath,
  rel_path_base_to_parent_of_user_restricted_folder = file.path("Reports", "2022",
    "Mesos"),
  warn = TRUE,
  local_main_password_path = ".main_htpasswd_public",
  username_folder_matching_df = NULL,
  universal_usernames = c("admin"),
  log_rounds = 12,
  append_users = TRUE,
  password_input = "prompt",
  type = c("netlify", "apache"),
  create_main_htaccess = FALSE
)
```

## Arguments

- remote_basepath:

  String. Folder where site will be located if using FTP-server. Needed
  for .htaccess-files.

- local_basepath:

  String. Local folder for website, typically "\_site".

- rel_path_base_to_parent_of_user_restricted_folder:

  String, relative path from basepath to the folder where the restricted
  folders are located. (E.g. the "mesos"-folder)

- warn:

  Flag. Whether to provide warning or error if paths do not exist.

- local_main_password_path:

  String. Path to main file containing all usernames and passwords
  formatted with a colon between username and password.

- username_folder_matching_df:

  Data frame. If NULL (default), will use folder names as usernames.
  Otherwise, a data frame with two columns: "folder" and "username"
  where "folder" is the name of the folder and "username" is the
  username for that folder.

- universal_usernames:

  Character vector. Usernames in local_main_htpasswd_path which always
  have access to folder

- log_rounds:

  Integer, number of rounds in the bcrypt algorithm. The higher the more
  time consuming and harder to brute-force.

- append_users:

  Boolean, if TRUE (default) will create new users and add them to
  local_main_password_path. See also password_input.

- password_input:

  String, either "prompt" which asks the user for input. Alternatively,
  a number stored as string for a generated random password of said
  length: "8", "10", "12", "16"

- type:

  Character vector. "netlify" will create \_headers file used for
  Netlify. "apache" will create .htaccess and .htpasswd files used for
  general FTP-servers.

- create_main_htaccess:

  Logical. If TRUE, creates a main .htaccess file in local_basepath with
  security headers (HSTS, X-Content-Type-Options, X-Frame-Options,
  etc.). Only applicable when type includes "apache". Default is FALSE.

## Value

String, the path to the newly created \_headers-file or .htaccess files.
