extends Object

class_name Encryption

const ENCRYPTION_KEY = "LeniKiko2022GoGo" # Key must be either 16 or 32 bytes.
const ENCRYPTION_BLOCK = 16
const ENCRYPTION_PADDING = " "

static func decrypt(encrypted_base_64: String):
	var aes = AESContext.new()
	
	aes.start(AESContext.MODE_ECB_DECRYPT, ENCRYPTION_KEY.to_utf8())
	var decrypted = aes.update(Marshalls.base64_to_raw(encrypted_base_64))
	aes.finish()
	
	return decrypted.get_string_from_utf8()

static func encrypt(data: String): 
	var aes = AESContext.new()
	#	Pads data if not multiple of the encryption block
	while data.length() % ENCRYPTION_BLOCK != 0:
		data = data + ENCRYPTION_PADDING
	
	# Encrypt ECB
	aes.start(AESContext.MODE_ECB_ENCRYPT, ENCRYPTION_KEY.to_utf8())
	var encrypted = aes.update(data.to_utf8())
	aes.finish()
	
	
	
#	Converts the encrypted data to base64 and makes it url compatible
	return Marshalls.raw_to_base64(encrypted)
