require 'digest/sha2'
require 'openssl'

module Swak
  # Uses AES-256-ECB encryption, outputs a string
  # - encrypted_data: an encrypted data string output by encrypt
  # - key: plain text key (uses SHA2 to digest it into a form openssh can use)
  def Swak.decrypt(encrypted_data, key)
    aes = OpenSSL::Cipher::Cipher.new("AES-256-ECB")
    aes.decrypt
    aes.key = Digest::SHA1.hexdigest(key)
    aes.update(encrypted_data) + aes.final
  end

  # Uses AES-256-ECB encryption, outputs a string
  # - data: A string of data
  # - key: plain text key (uses SHA2 to digest it into a form openssh can use)
  def Swak.encrypt(data, key)
    aes = OpenSSL::Cipher::Cipher.new("AES-256-ECB")
    aes.encrypt
    aes.key = Digest::SHA1.hexdigest(key)
    aes.update(data) + aes.final
  end

end
