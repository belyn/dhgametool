// ConsoleApplication1.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "zip_support/ZipUtils.h"

unsigned char *byte_5568F0 = new unsigned char[64]{
	0x1B, 0xC3, 0xAE, 0xF5, 0x87, 0x8D, 0xAF, 0x3F, 
	0x2B, 0xC2, 0xD3, 0xFC, 0xFE, 0xE6, 0xF3, 0xA1, 
	0x3C, 0x3C, 0xFC, 0xB4, 0x65, 0x3C, 0xB5, 0x3C, 
	0x7F, 0x83, 0x94, 0xBA, 0x3B, 0x2B, 0xB2, 0x73, 
	0x5B, 0xEF, 0xEE, 0xE2, 0xA3, 0x3B, 0x2B, 0xCC, 
	0x66, 0x3D, 0xE5, 0x2C, 0xD7, 0x4D, 0x2E, 0x17, 
	0xE6, 0xF3, 0x0,  0x0,  0x0,  0x0,  0x0,  0x0, 
	0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0
};

char unk_5568E0[16] = {
	0x5F, 0xFA, 0xE7, 0xBA,
	0xCC, 0xFE, 0xFB, 0x5C,
	0x1A, 0xFB, 0xBD, 0xBB,
	0x93, 0xB5, 0x83, 0xE7
};

int decodeData(unsigned char *data, xxtea_long data_len, unsigned char *key, xxtea_long key_len) {
	char v15 = 0;
	char v21[16] = {0};
	char v12 = 0u;
	unsigned char* v13 = data;
	xxtea_long v14 = data_len;
	do
	{
		v15 = byte_5568F0[v12++ + 21];
		--v14;
		*v13++ ^= v15;
		if (v12 == 29)
			v12 = 7;
	} while (v14);

	memcpy(v21, unk_5568E0, 16);
	v21[0] = 0x44;
	char v17 = 1;
	char v18 = 1;
	char v19 = 1;
	do
	{
		if (v17 == 21)
			v17 = 7;
		v19 = byte_5568F0[v17++];
		v21[v18] ^= v19;
		++v18;
	} while (v18 != 16);
	memcpy(key, v21, 16);

	return 0;
}

int decryptFile(const std::string& infile) {
	std::ifstream luafile(infile, std::ifstream::binary);
	if (!luafile.is_open()) {
		printf("%s not found£¡\n", infile.c_str());
		return -2;
	}

	// get length of file:
	luafile.seekg(0, luafile.end);
	unsigned int length = luafile.tellg();
	luafile.seekg(0, luafile.beg);
	char * buf = new char[length];
	luafile.read(buf, length);
	luafile.close();

	unsigned char sign[] = "DHGAMES";
	unsigned char key[16] = {
		0x72, 0x35, 0x53, 0x74,
		0x75, 0x59, 0x74, 0x38,
		0x36, 0x49, 0x31, 0x70,
		0x5A, 0x38, 0x36, 0x45
	};

	bool isEncoder = false;
	unsigned int len = strlen((char *)sign);
	if (length <= len) {
		return 0;
	}

	for (int i = 0; i < len; ++i) {
		isEncoder = buf[i] == sign[i];
		if (!isEncoder) {
			break;
		}
	}

	if (isEncoder) {
		decodeData((unsigned char*)(buf + len),
			(xxtea_long)(length - len),
			(unsigned char*)key,
			(xxtea_long)16);

		xxtea_long newLen = 0;
		unsigned char* buffer = xxtea_decrypt((unsigned char*)(buf + len),
			(xxtea_long)(length - len),
			(unsigned char*)key,
			(xxtea_long)16,
			&newLen);
		std::ofstream outLuafile(infile, std::ifstream::binary);
		if (newLen > 0) {
			unsigned char zipsign[] = "DHZAMES";
			bool bIsZipEncoder = false;
			unsigned int nZipSignLen = strlen((char *)zipsign);
			if (newLen > nZipSignLen) {
				for (int i = 0; i < len; ++i) {
					bIsZipEncoder = buffer[i] == zipsign[i];
					if (!bIsZipEncoder) {
						break;
					}
				}
			}

			if (bIsZipEncoder) {

				unsigned char *deflated = NULL;
				int deflatedLen = ZipUtils::ccInflateMemory(buffer + nZipSignLen, newLen - nZipSignLen, &deflated);
				if (!deflated) {
					printf("%s>>>>>>>>>>>>>>>>failed with zip!\n", infile.c_str());
					return 0;
				}

				outLuafile.write((const char*)deflated, deflatedLen);
				outLuafile.flush();
				outLuafile.close();

				free(buffer);

				printf("%s>>>>>>>>>>>>>>>>suc with zip!\n", infile.c_str());
				return 0;
			}
			else {
				outLuafile.write((const char*)buffer, newLen);
				outLuafile.flush();
				outLuafile.close();

				free(buffer);

				printf("%s>>>>>>>>>>>>>>>>suc without zip!\n", infile.c_str());
			}
		}
		else {
			outLuafile.write((const char*)buf + len, length - len);
			outLuafile.flush();
			outLuafile.close();

			free(buffer);

			printf("%s>>>>>>>>>>>>>>>>failed!\n", infile.c_str());
		}
	}
	else {
		printf("%s>>>>>>>>>>>>>>>>no encrypt!\n", infile.c_str());
	}

	delete buf;
}


int main(int argc, char** argv) {
	if (argc < 2) {
		printf("param error \n");
		return -1;
	}
	std::string infile = argv[1];
	
	decryptFile(infile);
    return 0;
}

