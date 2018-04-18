defmodule Stormchat.Mailer do
  @config domain: Application.get_env(:stormchat, :mailgun_domain),
          key: Application.get_env(:stormchat, :mailgun_key)
  use Mailgun.Client, @config

  @from "postmaster@mg.stormchat.sushiparty.blog"

  def send_alert_email(user, html) do
    send_email to: user.email,
               from: @from,
               subject: "New weather alerts in your area!",
               html: html
  end

end
