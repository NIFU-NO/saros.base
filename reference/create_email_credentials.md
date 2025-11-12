# Create Data Frame Containing Email Drafts with User Credentials

Create Data Frame Containing Email Drafts with User Credentials

## Usage

``` r
create_email_credentials(
  email_data_frame,
  email_col = "email",
  username_col = "username",
  local_main_password_path = ".htpasswd_private",
  ignore_missing_emails = FALSE,
  email_body = "Login credentials are \nUsername: {username},\nPassword: {password}",
  email_subject = "User credentials for website example.net.",
  ...
)
```

## Arguments

- email_data_frame:

  Data.frame/tibble with (at least) emails and usernames

- email_col:

  String, name of email column

- username_col:

  String, name of username column in email_data_frame

- local_main_password_path:

  Path to a local .htpasswd file containing username:password header and
  : as separator.

- ignore_missing_emails:

  Flag, defaults to FALSE. Whether usernames existing in password file
  but not email file will result in warnings.

- email_body, email_subject:

  String, subject line and email body respectively. Supports glue syntax
  referring to columns found in the email data frame or password file.

- ...:

  Dynamic dots forwarded to quarto::quarto_render

## Value

Data.frame
