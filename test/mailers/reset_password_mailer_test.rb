require 'test_helper'

class ResetPasswordMailerTest < ActionMailer::TestCase
  test "reset_password" do
    mail = ResetPasswordMailer.reset_password
    assert_equal "Reset password", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
