-- Command line was: E:\github\dhgametool\scripts\config\buff.lua 

local buff = {}
buff[1] = {name = "atk", isPercent = 1, icon1 = 1, icon2 = 4}
buff[2] = {name = "hp", isPercent = 1, icon1 = 2, icon2 = 3}
buff[3] = {name = "arm", isPercent = 1, icon1 = 5, icon2 = 6}
buff[4] = {name = "spd", isPercent = 1, icon1 = 15, icon2 = 16}
buff[5] = {name = "energy", isPercent = 1}
buff[6] = {name = "hit", isPercent = 1, showPercent = 1, factor = 2000, icon1 = 17, icon2 = 18}
buff[7] = {name = "miss", isPercent = 1, showPercent = 1, factor = 2000, icon1 = 9, icon2 = 10}
buff[8] = {name = "crit", isPercent = 1, showPercent = 1, factor = 2000, icon1 = 11, icon2 = 12}
buff[9] = {name = "trueAtk", isPercent = 1, showPercent = 1, factor = 1000, icon1 = 19, icon2 = 20}
buff[10] = {name = "brk", isPercent = 1, showPercent = 1, factor = 1000, icon1 = 7, icon2 = 8}
buff[11] = {name = "stun", isPercent = 1, fx = {2060}}
buff[12] = {name = "ice", isPercent = 1, fx = {2010}}
buff[13] = {name = "stone", isPercent = 1, fx = {2020}}
buff[14] = {name = "forbid", isPercent = 1, fx = {2050}}
buff[15] = {name = "revive", isPercent = 1, fx = {2031, 2032}}
buff[16] = {name = "critTime", isPercent = 1, showPercent = 1, factor = 2000, icon1 = 13, icon2 = 14}
buff[17] = {name = "free", isPercent = 1, showPercent = 1, factor = 1000}
buff[18] = {name = "sklP", isPercent = 1, showPercent = 1, factor = 1000, icon1 = 26, icon2 = 27}
buff[19] = {name = "decDmg", isPercent = 1, showPercent = 1, factor = 1000, icon1 = 28, icon2 = 29}
buff[21] = {name = "hurt", isPercent = 2}
buff[22] = {name = "dot", isPercent = 2, icon1 = 25}
buff[23] = {name = "heal", isPercent = 2}
buff[24] = {name = "hot", isPercent = 2, icon1 = 24}
buff[25] = {name = "healP", isPercent = 2, fx = {2070}}
buff[26] = {name = "trueHurt", isPercent = 2}
buff[27] = {name = "siphonAtk", isPercent = 2, icon1 = 1, icon2 = 4}
buff[28] = {name = "siphonHp", isPercent = 2, fx = {2070}}
buff[29] = {name = "siphonArm", isPercent = 2, icon1 = 5, icon2 = 6}
buff[30] = {name = "shield", isPercent = 2, fx = {2040}}
buff[31] = {name = "brier", isPercent = 2}
buff[32] = {name = "dotFire", isPercent = 2, icon1 = 21}
buff[33] = {name = "dotPoison", isPercent = 2, icon1 = 22}
buff[34] = {name = "dotBlood", isPercent = 2, icon1 = 23}
buff[35] = {name = "rImpress", isPercent = 2, fx = {2100, 2101}}
buff[36] = {name = "cImpress", isPercent = 2, fx = {2080, 2081}}
buff[37] = {name = "rImpressB", isPercent = 1, fx = {2110}}
buff[38] = {name = "cImpressB", isPercent = 1, fx = {2090}}
buff[39] = {name = "fImpress", isPercent = 2, fx = {2120, 2121}, hero = {65316, 75309, 5301}}
buff[40] = {name = "weak", isPercent = 2, fx = {2180, 2181}}
buff[41] = {name = "oImpress", isPercent = 2, fx = {2140, 2141}}
buff[42] = {name = "dotThu", isPercent = 2, fx = {5523}}
buff[43] = {name = "hotP", isPercent = 2}
buff[44] = {name = "shadowF", isPercent = 2, fx = {2160}}
buff[45] = {name = "lightS", isPercent = 2, fx = {2150}}
buff[46] = {name = "kImpress", isPercent = 2, fx = {2170, 2171}, hero = {65219, 75212, 5212}}
buff[47] = {name = "sImpress", isPercent = 2, fx = {2173, 2174}, hero = {65219, 75212, 5212}}
buff[48] = {name = "addHurt", isPercent = 2}
buff[49] = {name = "dotBlast", isPercent = 2}
buff[50] = {name = "healUp", isPercent = 2, icon1 = 34, icon2 = 35}
buff[51] = {name = "beHealUp", isPercent = 2, icon1 = 36, icon2 = 37}
buff[53] = {name = "fear", isPercent = 1, fx = {2191}}
buff[54] = {name = "hpBelowFear", isPercent = 1, fx = {2191}}
buff[55] = {name = "decShield", isPercent = 1, fx = {2190}, fxNoRepeat = 1}
buff[65] = {name = "atkP", isPercent = 2, showPercent = 1, icon1 = 1, icon2 = 4}
buff[66] = {name = "hpP", isPercent = 2, showPercent = 1, icon1 = 2, icon2 = 3}
buff[67] = {name = "armP", isPercent = 2, showPercent = 1, icon1 = 5, icon2 = 6}
buff[75] = {name = "atkPos", isPercent = 2}
buff[76] = {name = "hpPos", isPercent = 2}
buff[77] = {name = "armPos", isPercent = 2}
buff[78] = {name = "spdPos", isPercent = 1}
buff[79] = {name = "hitPos", isPercent = 1}
buff[80] = {name = "missPos", isPercent = 1}
buff[81] = {name = "critPos", isPercent = 1}
buff[82] = {name = "critTimePos", isPercent = 1}
buff[83] = {name = "stunB", isPercent = 2}
buff[84] = {name = "iceB", isPercent = 2}
buff[85] = {name = "stoneB", isPercent = 2}
buff[86] = {name = "dotFireB", isPercent = 2}
buff[87] = {name = "dotPoisonB", isPercent = 2}
buff[88] = {name = "dotBloodB", isPercent = 2}
buff[89] = {name = "zs", isPercent = 2, showPercent = 1}
buff[90] = {name = "fs", isPercent = 2, showPercent = 1}
buff[91] = {name = "ms", isPercent = 2, showPercent = 1}
buff[92] = {name = "ck", isPercent = 2, showPercent = 1}
buff[93] = {name = "yx", isPercent = 2, showPercent = 1}
buff[94] = {name = "addHurtOld", isPercent = 2}
buff[95] = {name = "changeCombat", isPercent = 1}
buff[96] = {name = "fsStun", isPercent = 1}
buff[97] = {name = "fsDotBlood", isPercent = 2}
buff[98] = {name = "zsIce", isPercent = 1}
buff[99] = {name = "zsStun", isPercent = 1}
buff[100] = {name = "zsForbid", isPercent = 1}
buff[101] = {name = "zsHurt", isPercent = 2}
buff[102] = {name = "zsArmP", isPercent = 2}
buff[103] = {name = "ckStone", isPercent = 1}
buff[104] = {name = "ckForbid", isPercent = 1}
buff[105] = {name = "ckHurt", isPercent = 2}
buff[106] = {name = "msForbid", isPercent = 1}
buff[107] = {name = "yxHurt", isPercent = 2}
buff[108] = {name = "yxAtkP", isPercent = 2}
buff[109] = {name = "zsHpPO", isPercent = 2, showPercent = 1}
buff[110] = {name = "zsAtkPO", isPercent = 2, showPercent = 1}
buff[111] = {name = "zsCritO", isPercent = 1, showPercent = 1, factor = 2000}
buff[112] = {name = "zsMissO", isPercent = 1, showPercent = 1, factor = 2000}
buff[113] = {name = "zsSklPO", isPercent = 1, showPercent = 1, factor = 1000}
buff[114] = {name = "fsHpPO", isPercent = 2, showPercent = 1}
buff[115] = {name = "fsAtkPO", isPercent = 2, showPercent = 1}
buff[116] = {name = "fsCritO", isPercent = 1, showPercent = 1, factor = 2000}
buff[117] = {name = "fsHitO", isPercent = 1, showPercent = 1, factor = 2000}
buff[118] = {name = "fsSklPO", isPercent = 1, showPercent = 1, factor = 1000}
buff[119] = {name = "ckHpPO", isPercent = 2, showPercent = 1}
buff[120] = {name = "ckCritTimeO", isPercent = 1, showPercent = 1, factor = 2000}
buff[121] = {name = "ckCritO", isPercent = 1, showPercent = 1, factor = 2000}
buff[122] = {name = "ckBrkO", isPercent = 1, showPercent = 1, factor = 1000}
buff[123] = {name = "ckSklPO", isPercent = 1, showPercent = 1, factor = 1000}
buff[124] = {name = "yxHpPO", isPercent = 2, showPercent = 1}
buff[125] = {name = "yxAtkPO", isPercent = 2, showPercent = 1}
buff[126] = {name = "yxMissO", isPercent = 1, showPercent = 1, factor = 2000}
buff[127] = {name = "yxHitO", isPercent = 1, showPercent = 1, factor = 2000}
buff[128] = {name = "yxSklPO", isPercent = 1, showPercent = 1, factor = 1000}
buff[129] = {name = "msHpPO", isPercent = 2, showPercent = 1}
buff[130] = {name = "msMissO", isPercent = 1, showPercent = 1, factor = 2000}
buff[131] = {name = "msCritO", isPercent = 1, showPercent = 1, factor = 2000}
buff[132] = {name = "msSpdO", isPercent = 1}
buff[133] = {name = "msSklPO", isPercent = 1, showPercent = 1, factor = 1000}
buff[134] = {name = "ckStun", isPercent = 1}
buff[135] = {name = "mhurt", isPercent = 1}
buff[136] = {name = "mdotFire", isPercent = 1}
buff[137] = {name = "mdotPoison", isPercent = 1}
buff[138] = {name = "mdotBlood", isPercent = 1}
buff[139] = {name = "yxDotBlood", isPercent = 2}
buff[140] = {name = "phurt", isPercent = 2}
buff[141] = {name = "addHurtd", isPercent = 2}
buff[142] = {name = "zsDotFire", isPercent = 2}
buff[143] = {name = "yxStun", isPercent = 1}
buff[144] = {name = "fsForbid", isPercent = 1}
buff[145] = {name = "ckDotPoison", isPercent = 2}
buff[146] = {name = "msStun", isPercent = 1}
buff[147] = {name = "msDotFire", isPercent = 2}
buff[148] = {name = "zsSpdO", isPercent = 1}
buff[149] = {name = "fsSpdO", isPercent = 1}
buff[150] = {name = "ckSpdO", isPercent = 1}
buff[151] = {name = "ckAtkPO", isPercent = 2, showPercent = 1}
buff[152] = {name = "yxSpdO", isPercent = 1}
buff[153] = {name = "msAtkPO", isPercent = 2, showPercent = 1}
buff[154] = {name = "iceless", isPercent = 1}
buff[155] = {name = "stoneless", isPercent = 1}
buff[156] = {name = "stunless", isPercent = 1}
buff[157] = {name = "forbidless", isPercent = 1}
buff[158] = {name = "stunH", isPercent = 1}
buff[159] = {name = "hurtH", isPercent = 2}
buff[160] = {name = "msHurt", isPercent = 2}
buff[161] = {name = "forbidH", isPercent = 1}
buff[162] = {name = "phurtH", isPercent = 2}
buff[163] = {name = "dotless", isPercent = 1}
buff[164] = {name = "hurthpB", isPercent = 2}
buff[165] = {name = "poisonStun", isPercent = 1}
buff[166] = {name = "healLossP", isPercent = 2, fx = {2070}}
buff[167] = {name = "stonePos", isPercent = 1}
buff[168] = {name = "dotFireL", isPercent = 2}
buff[169] = {name = "phurtA", isPercent = 2}
buff[170] = {name = "dotlessFire", isPercent = 1}
buff[171] = {name = "dotlessBlood", isPercent = 1}
buff[172] = {name = "energyByFire", isPercent = 1}
buff[173] = {name = "healByBlood", isPercent = 2}
buff[174] = {name = "critDotFire", isPercent = 1, showPercent = 1, factor = 2000}
buff[175] = {name = "forbidPos", isPercent = 1}
buff[176] = {name = "hurtCritPos", isPercent = 2}
buff[177] = {name = "phurtAN", isPercent = 2}
buff[178] = {name = "phurtAPos"}
buff[179] = {name = "paddhurtAN"}
buff[180] = {name = "extraHurt", isPercent = 2}
return buff

