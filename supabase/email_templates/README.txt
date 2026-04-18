Supabase Auth e-posta şablonları (Dashboard'a yapıştır)

Bu HTML dosyaları Supabase'in Go template değişkenleriyle uyumludur (ör. {{ .ConfirmationURL }}).

Nereden yapıştırılır:
  Supabase Dashboard → Authentication → Email Templates

Hangi dosya hangi şablon:
  confirm_signup.html   → Confirm signup
  reset_password.html   → Reset password
  magic_link.html       → Magic link
  change_email.html     → Change email address
  invite_user.html      → Invite user

Subject (konu) satırlarını Dashboard'da ayrıca düzenleyebilirsin (ör. "Hestora — Hesabını doğrula").

Not: Şablonları kaydettikten sonra "Send test" ile test postası atılabilir (planına bağlı).

Mobil doğrulama (boş ekran önleme):
  Dashboard → Authentication → URL Configuration → Redirect URLs içine
  com.hestora.hestora://auth-callback
  eklenmeli. Kayıtta kullanılan emailRedirectTo ile aynı olmalı.
