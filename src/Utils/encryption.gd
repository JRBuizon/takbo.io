extends Object

class_name Encryption

const ENCRYPTION_KEY = "LeniKiko2022GoGo" # Key must be either 16 or 32 bytes.
const ENCRYPTION_BLOCK = 16
const ENCRYPTION_PADDING = " "

static func decrypt_base64(encrypted_string: String):
	var aes = AESContext.new()
	
	# Still accepts base64 encoded strings
	var encrypted = Marshalls.base64_to_raw(encrypted_string)
	
	aes.start(AESContext.MODE_ECB_DECRYPT, ENCRYPTION_KEY.to_utf8())
	var decrypted = aes.update(encrypted)
	aes.finish()
	
	return decrypted.get_string_from_utf8()

static func decrypt_hex(encrypted_string: String):
	var aes = AESContext.new()
	
	# If not base64, assumes hexadecimals
	var bigrams = encrypted_string.bigrams()
	
	var decrypted_hex = []
	for index in range(0, len(bigrams), 2): 
		var gram = bigrams[index]
		var val = gram.indent("0x").hex_to_int()
		if val == null: 
			return null
			
		decrypted_hex.append(val)
	
	aes.start(AESContext.MODE_ECB_DECRYPT, ENCRYPTION_KEY.to_utf8())
	var decrypted = aes.update(decrypted_hex)
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
	
#	Converts the encrypted data to hex and makes it url compatible
	return encrypted.hex_encode()
