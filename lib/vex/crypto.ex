defmodule Vex.Crypto do
  @key_base "vex_secret_key"

  # Client API
  def encrypt(plaintext) do
    key = generate_key()
    iv = :crypto.strong_rand_bytes(16) # Initialization vector

    ciphertext = :crypto.crypto_one_time(:aes_128_ctr, key, iv, plaintext, true)
    {iv, ciphertext}
  end

  def decrypt({iv, ciphertext}) do
    key = generate_key()
    :crypto.crypto_one_time(:aes_128_ctr, key, iv, ciphertext, false)
  end

  # Private functions
  defp generate_key do
    # Simple key derivation - in production, use proper key management!
    :crypto.hash(:sha256, @key_base) |> binary_part(0,16) # 128-bit key
  end
end
