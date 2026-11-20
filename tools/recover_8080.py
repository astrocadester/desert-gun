#!/usr/bin/env python3
"""Native Intel 8080 RE from original Midway ROM devices.
Root native traversal includes reset/IRQ, bytecode vectors and proven stack/HL
continuations. Genuine ROM image/text/script data stay typed, never guessed code.
"""
import argparse,hashlib,json,re,zipfile
from audit_words import audit
from pathlib import Path
from collections import deque,Counter

ROOT=Path(__file__).resolve().parents[1]
CFG={"desertgun":("desertgu.zip",("9316.1h","9316.1g","9316.1f","desertgu.e"),2048)}
REG="B C D E H L (HL) A".split()
PAIR=("BC","DE","HL","SP")
STACK=("BC","DE","HL","AF")
COND=("NZ","Z","NC","C","PO","PE","P","M")
ARITH=("ADD A,","ADC A,","SUB ","SBC A,","AND ","XOR ","OR ","CP ")
ILLEGAL={8,16,24,32,40,48,56,0xcb,0xdd,0xed,0xfd,0xd9}
def decode(mem,pc):
    op=mem[pc];b=mem[pc+1] if pc+1<len(mem) else 0
    w=b+((mem[pc+2] if pc+2<len(mem) else 0)<<8)
    H=f"${w:04X}";B=f"${b:02X}"
    if op in ILLEGAL:return None,1,"data",None
    if 0x40<=op<=0x7f:
        return ("HALT",1,"stop",None) if op==0x76 else (f"LD {REG[op>>3&7]},{REG[op&7]}",1,"next",None)
    if 0x80<=op<=0xbf:return ARITH[op>>3&7]+REG[op&7],1,"next",None
    if op&0xcf==1:return f"LD {PAIR[op>>4&3]},{H}",3,"next",None
    if op&0xcf==3:return f"INC {PAIR[op>>4&3]}",1,"next",None
    if op&0xcf==11:return f"DEC {PAIR[op>>4&3]}",1,"next",None
    if op&0xcf==9:return f"ADD HL,{PAIR[op>>4&3]}",1,"next",None
    if op&0xc7==4:return f"INC {REG[op>>3&7]}",1,"next",None
    if op&0xc7==5:return f"DEC {REG[op>>3&7]}",1,"next",None
    if op&0xc7==6:return f"LD {REG[op>>3&7]},{B}",2,"next",None
    if op in (0x22,0x2a,0x32,0x3a):
        return {0x22:f"LD ({H}),HL",0x2a:f"LD HL,({H})",0x32:f"LD ({H}),A",0x3a:f"LD A,({H})"}[op],3,"next",None
    if op&0xc7==0xc0:return "RET "+COND[op>>3&7],1,"next",None
    if op==0xc9:return "RET",1,"stop",None
    if op&0xc7==0xc2:return "JP "+COND[op>>3&7]+","+H,3,"branch",w
    if op==0xc3:return "JP "+H,3,"jump",w
    if op&0xc7==0xc4:return "CALL "+COND[op>>3&7]+","+H,3,"call",w
    if op==0xcd:return "CALL "+H,3,"call",w
    if op&0xcf==0xc1:return "POP "+STACK[op>>4&3],1,"next",None
    if op&0xcf==0xc5:return "PUSH "+STACK[op>>4&3],1,"next",None
    if op&0xc7==0xc7:return f"RST ${op&0x38:02X}",1,"call",op&0x38
    if op&0xc7==0xc6:return ARITH[op>>3&7]+B,2,"next",None
    if op==0xd3:return f"OUT ({B}),A",2,"next",None
    if op==0xdb:return f"IN A,({B})",2,"next",None
    single={0:"NOP",2:"LD (BC),A",10:"LD A,(BC)",0x12:"LD (DE),A",0x1a:"LD A,(DE)",
            7:"RLCA",15:"RRCA",0x17:"RLA",0x1f:"RRA",0x27:"DAA",0x2f:"CPL",0x37:"SCF",
            0x3f:"CCF",0xe9:"JP (HL)",0xf9:"LD SP,HL",0xeb:"EX DE,HL",
            0xe3:"EX (SP),HL",0xf3:"DI",0xfb:"EI"}
    if op in single:return single[op],1,"stop" if op==0xe9 else "next",None
    return None,1,"data",None

def recover(mem,roots):
    q=deque(roots);code={};owned={};entries=set(roots);edges=[]
    while q:
        pc=q.popleft()
        for _ in range(4096):
            if pc not in range(len(mem)) or pc in owned:break
            asm,size,kind,target=decode(mem,pc)
            if asm is None or pc+size>len(mem) or any(pc+i in owned for i in range(size)):break
            code[pc]=(asm,size,kind,target)
            for i in range(size):owned[pc+i]=pc
            if target is not None:
                edges.append({"source":pc,"target":target,"type":kind})
                if target<len(mem):q.append(target);entries.add(target)
            if kind in ("stop","jump"):break
            pc+=size
    return code,owned,entries,edges

WORD_NAMES=("FRAME_SCHEDULER","RENDER_MODE_A","SET_MODE","SET_RENDER_POINTER","SCRIPT_GOTO","STORE_IMMEDIATE","CLEAR_DISPLAY","INIT_DESCRIPTOR","INIT_RENDER","RENDER_MODE_B","CLEAR_BIT3","RESET_ROUND","RENDER_PACKET")
# Semantic source annotations; kept here so build.sh regeneration preserves the RE.
SEMANTIC_LABELS = {'1033':'DECODE_DESCRIPTOR_NIBBLE','1047':'WORD_08_DRAW_BRANCH_ENTRY','1142':'RENDER_FRAME_DESCRIPTOR','1181':'FLOW_WORD_1181','1214':'FLOW_FRAME_1214','1223':'FLOW_FRAME_1223','1232':'SERVICE_GAME_STATE_201E','1246':'FLOW_FRAME_1246','1318':'FRAME_SERVICE_1318','1345':'FLOW_FRAME_1345','1356':'FLOW_FRAME_1356','1372':'UPDATE_GAME_TIMER_2032','1422':'INITIALIZE_OBJECT_TIMER_2032','1442':'FLOW_FRAME_1442','1472':'FETCH_GUN_SHAPE_TABLE_BYTE','1485':'FLOW_FRAME_1485','1492':'FLOW_FRAME_1492','1494':'SET_OBJECT_FLAG_ACTIVE','1503':'FRAME_REBUILD_OBJECTS','1505':'FLOW_OBJECT_1505','1523':'FLOW_OBJECT_1523','1537':'FLOW_OBJECT_1537','1538':'FLOW_OBJECT_1538','1545':'FLOW_OBJECT_1545','1718':'FLOW_GAME_1718','1748':'FLOW_GAME_1748','1769':'FLOW_GAME_1769','1776':'FLOW_GAME_1776','1787':'FLOW_GAME_1787','1802':'FLOW_GAME_1802','1815':'FLOW_GAME_1815','1825':'FLOW_GAME_1825','1848':'FLOW_GAME_1848','1854':'FLOW_GAME_1854','1858':'FLOW_GAME_1858','1906':'FLOW_GAME_1906','1936':'FRAME_SERVICE_1936','1951':'FLOW_GAME_1951','1977':'FLOW_GAME_1977','0000':'RESET_ENTRY','0008':'IRQ_VECTOR_08','0010':'IRQ_VECTOR_10','0018':'BOOT_RAM_ROM_TEST','0027':'TEST_RAM_PATTERN_START','002A':'TEST_RAM_FORWARD_SCAN','003F':'FLOW_TEST_003F','0041':'FLOW_TEST_0041','0048':'TEST_RAM_REVERSE_SCAN','0063':'FLOW_TEST_0063','0065':'FLOW_TEST_0065','0079':'FLOW_TEST_0079','007B':'FLOW_TEST_007B','007E':'TEST_RAM_FINAL_SCAN','009A':'FLOW_TEST_009A','009C':'FLOW_TEST_009C','00A1':'TEST_RAM_RESULT','00BC':'FLOW_TEST_00BC','00C2':'FLOW_TEST_00C2','00C8':'FLOW_TEST_00C8','00D9':'TEST_ROM_CHECKSUM','00E6':'TEST_ROM_BANK_LOOP','00EB':'TEST_ROM_BYTE_LOOP','0105':'FLOW_TEST_0105','011C':'TEST_FAILURE_HALT','0132':'DRAW_ENCODED_GRAPHIC','0133':'DRAW_GRAPHIC_COMMAND_FETCH','013B':'DRAW_ADVANCE_VIDEO_CURSOR','0144':'DRAW_ADVANCE_LOOP','014B':'FLOW_DRAW_014B','0154':'FLOW_DRAW_0154','0167':'DRAW_GRAPHIC_MODE_B','0172':'FLOW_DRAW_0172','017C':'FLOW_DRAW_017C','0183':'FLOW_DRAW_0183','01B1':'SHIFT_VIDEO_ADDRESS_THREE','01B3':'FLOW_DRAW_01B3','01C7':'TEST_DISPLAY_ENTRY','0273':'DRAW_LOOKUP_GLYPH','027B':'FLOW_DRAW_027B','0281':'DRAW_LOOKUP_REPEAT','0404':'IRQ_08_SERVICE','0424':'FLOW_IO_0424','0441':'FLOW_IO_0441','0449':'IRQ_PROCESS_ACTIVE_OBJECT','0456':'IRQ_10_SERVICE','046C':'FLOW_IO_046C','047C':'FLOW_IO_047C','0481':'FLOW_IO_0481','0486':'IRQ_SERVICE_TIMER_201F','0495':'FLOW_IO_0495','04A2':'FLOW_IO_04A2','04AD':'FLOW_IO_04AD','04C3':'FLOW_IO_04C3','04CD':'FLOW_IO_04CD','04E0':'FLOW_IO_04E0','0547':'PROCESS_OBJECT_BIT6_FLAGS','0566':'FLOW_IO_0566','0587':'FLOW_IO_0587','0589':'FLOW_IO_0589','05A6':'FLOW_IO_05A6','05A9':'FLOW_IO_05A9','05AB':'FLOW_IO_05AB','05C8':'CLEAR_OBJECT_PENDING_BIT5','05D6':'FLOW_IO_05D6','05E6':'FLOW_IO_05E6','05E8':'FLOW_IO_05E8','05F6':'SERVICE_TIMER_207C','061B':'FLOW_IO_061B','0627':'DECREMENT_NONZERO_TIMER_BYTE','0631':'FLOW_IO_0631','063A':'APPLY_RENDER_MODE_2031','065A':'FLOW_IO_065A','0675':'FLOW_IO_0675','067F':'FLOW_IO_067F','0685':'FLOW_IO_0685','0697':'FLOW_IO_0697','06A6':'FLOW_IO_06A6','06AA':'FLOW_IO_06AA','06B1':'ADVANCE_COUNTER_207F','06C4':'FLOW_IO_06C4','06CC':'FLOW_IO_06CC','06D1':'FLOW_IO_06D1','0F7B':'WORD_0C_DRAW_PACKET_ENTRY','0F8E':'WORD_09_DRAW_MODE_B_ENTRY','0F94':'WORD_01_DRAW_MODE_A_ENTRY','0F97':'WORD_DRAW_COMMON','0FA2':'WORD_02_SET_MODE_ENTRY','0FAB':'WORD_RETURN_STUB','0FAC':'WORD_03_SET_MODE_POINTER_ENTRY','0FBE':'WORD_04_SCRIPT_GOTO_ENTRY','0FC7':'WORD_05_STORE_BYTE_ENTRY','0FD3':'WORD_06_CLEAR_VIDEO_ENTRY','0FD7':'CLEAR_VIDEO_STACK_LOOP_START','0FDC':'CLEAR_VIDEO_PUSH_LOOP','0FF4':'COPY_SCREEN_ROW_DESCRIPTOR','0FF9':'COPY_SCREEN_ROW_LOOP','0FFB':'FLOW_TABLE_0FFB','100E':'WORD_07_INIT_DESCRIPTOR_ENTRY','106D':'WORD_0A_CLEAR_FLAG_ENTRY','107A':'WORD_0B_RESET_SCENE_ENTRY','116C':'FLOW_WORD_116C','117A':'FLOW_WORD_117A','11AC':'NORMALIZE_RENDER_DESCRIPTOR','11AE':'FLOW_WORD_11AE','11BA':'BOOT_MAIN_ENTRY','11D0':'BYTECODE_FETCH_DISPATCH','11EA':'BYTECODE_ZERO_FRAME_HANDOFF','120E':'SELECT_GAME_RECORD','121A':'UPDATE_OBJECT_FIELDS_2085','122B':'OR_GAME_FLAGS_2080','123E':'FLOW_FRAME_123E','124E':'UPDATE_OBJECT_PAIRS','125D':'COMPARE_OBJECT_PAIR_FLAGS','127E':'SCAN_OBJECT_FIELD_FLAGS','129E':'FRAME_SERVICE_129E','12B1':'FRAME_SERVICE_12B1','12E5':'FRAME_SERVICE_12E5','132E':'FLOW_FRAME_132E','133C':'FLOW_FRAME_133C','136C':'FLOW_FRAME_136C','138A':'FLOW_FRAME_138A','13A6':'CHECK_OBJECT_STATUS_LOW_BITS','13C1':'FLOW_FRAME_13C1','13F2':'FLOW_FRAME_13F2','145A':'STORE_OBJECT_FIELD_AND_LOOKUP','147C':'BOUND_GAME_COUNTER_2009','148C':'FLOW_FRAME_148C','14A0':'SET_OBJECT_FROM_SHAPE_TABLE','14A8':'FLOW_FRAME_14A8','14AE':'FLOW_FRAME_14AE','154C':'FLOW_OBJECT_154C','155E':'FLOW_OBJECT_155E','16F0':'CHECK_START_INPUT_EDGE','17A7':'FLOW_GAME_17A7','17D6':'FLOW_GAME_17D6','17DC':'FLOW_GAME_17DC','17EC':'FLOW_GAME_17EC','17FF':'FLOW_GAME_17FF','188C':'TEST_OBJECT_FLAG_BIT1','189F':'FLOW_GAME_189F','18A9':'INCREMENT_PACKED_BCD_SCORE','18B6':'CLAMP_GAME_STATE_TO_THREE','18C0':'FLOW_GAME_18C0','18C7':'FLOW_GAME_18C7','18D8':'FLOW_GAME_18D8','18E7':'FLOW_GAME_18E7','18EC':'FLOW_GAME_18EC','18F2':'FLOW_GAME_18F2','190F':'FLOW_GAME_190F','19AF':'FLOW_GAME_19AF','19CD':'FLOW_GAME_19CD','19E0':'FLOW_GAME_19E0','19F6':'COMPARE_TWO_BYTE_RECORD','1A06':'RENDER_WORD_PACKET','1A22':'READ_HIGH_BIT_TERMINATED_TEXT','1C22':'FLOW_GAME_1C22','1C2D':'FLOW_GAME_1C2D','1C35':'FLOW_GAME_1C35','1C43':'FLOW_GAME_1C43','1C5E':'FLOW_GAME_1C5E','1C69':'FLOW_GAME_1C69','1C7C':'FLOW_GAME_1C7C','1C9B':'FLOW_GAME_1C9B','1CB2':'FLOW_GAME_1CB2','1CC9':'FLOW_GAME_1CC9','1CD2':'FLOW_GAME_1CD2','1CDB':'FLOW_GAME_1CDB','1CE4':'FLOW_GAME_1CE4','1CEA':'FLOW_GAME_1CEA','1CFD':'FLOW_GAME_1CFD','1D0F':'FLOW_GAME_1D0F','1D1C':'FLOW_GAME_1D1C','1D36':'FLOW_GAME_1D36','1D4B':'FLOW_GAME_1D4B','1D58':'FLOW_GAME_1D58','1D60':'FLOW_GAME_1D60','1D64':'FLOW_GAME_1D64','1D6E':'FLOW_GAME_1D6E','1D77':'FLOW_GAME_1D77','1D8D':'FLOW_GAME_1D8D','1D95':'FLOW_GAME_1D95','1DBA':'FLOW_GAME_1DBA','1DC7':'FLOW_GAME_1DC7','1DCF':'FLOW_GAME_1DCF','1DEA':'FLOW_GAME_1DEA','1DF7':'FLOW_GAME_1DF7','1DF9':'FLOW_GAME_1DF9','1E0B':'FLOW_GAME_1E0B','1E11':'SAMPLE_INPUT_BIT6_EDGE','1E46':'FLOW_GAME_1E46','01D0':'TEST_DISPLAY_AFTER_RAM_CLEAR','01D7':'TEST_DISPLAY_PIXEL_LOOP','01E4':'TEST_DISPLAY_WRITE_PATTERN','01FA':'TEST_DISPLAY_AFTER_FILL','0226':'TEST_DISPLAY_IO_POLL','023E':'TEST_DISPLAY_INPUT_HANDLE','0252':'TEST_DISPLAY_DELAY_LOOP','0260':'TEST_DISPLAY_CLEAR_RAM_LOOP','025D':'TEST_DISPLAY_PREPARE_RAM','11C3':'BOOT_SCRIPT_AFTER_VIDEO_CLEAR','11C9':'BOOT_PUSH_INTERPRETER_RETURN','11E0':'BYTECODE_VECTOR_INDEX','1DE9':'NATIVE_RETURN_STUB_1DE9'}
DATA_LABELS = {'1564':'OBJECT_NATIVE_POINTERS','1580':'OBJECT_MOTION_DATA','1965':'SPRITE_COPY_POINTER_PAIRS','000F':'IRQ08_VECTOR_PAD','0017':'IRQ10_VECTOR_PAD','0121':'ROM_CHECKSUM_REFERENCE','01C3':'DISPLAY_TEST_MASKS','0268':'DISPLAY_TEST_GLYPH_STEPS','0288':'FONT_8PX_GLYPHS','04FB':'SCREEN_POSITION_LOOKUP','06DC':'GUN_GRAPHICS_AND_SHAPE_DATA','10AE':'OBJECT_SEQUENCE_TABLE','14BB':'FRAME_PATTERN_TABLE','1A2F':'SCREEN_MESSAGE_DIRECTORY','1A60':'SCREEN_MESSAGE_TEXT','1E4F':'ROM_FF_PADDING','191C':'DRAWING_COORDINATE_RECORDS','19FF':'DIFFICULTY_THRESHOLD_BYTES','1A37':'MESSAGE_SCREEN_COORDINATE_POINTERS'}
TYPED_POINTER_TABLES = {'1564':[14,'object routine pointers'],'1965':[9,'sprite data/video pointer pairs'],'1A2F':[4,'screen message string pointers'],'1A37':[4,'screen message destination pointers']}
FUNCTION_NOTES = {'1047':'Word $08: configure rendering and branch to second inline pointer.','0000':'Reset vector. Set native stack $2400 then test RAM and ROM.','0008':'IRQ $08 saves all general registers and enters game interrupt service.','0010':'IRQ $10 saves all general registers and enters second interrupt service.','0018':'Test RAM $2000–$3FFF patterns and ROM bank checksums.','00D9':'ROM-bank checksum reference list begins at $0121.','0132':'Draw compact encoded character/shape data to video memory.','01C7':'Stage the display diagnostic continuation in HL before clearing video memory.','01D0':'Display diagnostic resumes from clear-video helper; exercises screen RAM and hardware input.','025D':'Prepare diagnostic RAM for display test.','0404':'IRQ 08 native input/output service.','0456':'IRQ 10 native input/output service.','0F7B':'Word $0C: consume byte and two 16-bit pointers; transfer to drawing service.','0F8E':'Word $09: choose drawing continuation $0167.','0F94':'Word $01: choose drawing continuation $0132.','0FA2':'Word $02: write one byte to RAM $2031.','0FAC':'Word $03: store mode at $2030 and pointer at $2019.','0FBE':'Word $04: load inline script destination into RAM $2000.','0FC7':'Word $05: write immediate byte into inline 16-bit RAM address.','0FD3':'Word $06: clear video RAM via stack writes; resume at saved native continuation.','100E':'Word $07: initialize descriptor bytes in RAM $2040–$204A.','106D':'Word $0A: clear bit $08 in byte at inline address.','107A':'Word $0B: decrement round count and install script root $1676.','11BA':'Normal boot path stages $11C3 as continuation after video clear.','11C3':'Set script PC RAM $2000 to ROM $1633, push dispatcher return $11C9, enable IRQ and output port $04.','11D0':'Read script opcode via RAM $2000. Zero branches to frame scheduler; nonzero indexes vectors at $0F61.','11EA':'Run native frame services; conditional extra services depend on RAM $200D.','1A22':'Read text stream until high-bit-terminated character; select indexed string.','1033':'Rotate input nibble and update drawing descriptor state.','1232':'Read game-state entry at RAM $201E and branch on flags.','1372':'Check enable RAM $200D and timer RAM $2032.','1422':'Set timer RAM $2032 to $3C and prepare object state.','1472':'Index graphics data from ROM $06DC.','1494':'Write flag $01 and update related object-field values.','0167':'Draw alternate format/continuation using render state.','01B1':'Shift DE right three bits, then adjust display high byte.','0449':'Save descriptor pointer and call native object update helpers.','0486':'Check countdown RAM $201F and update secondary input state.','0547':'Process object entry only when bit $40 is set; update activity flags.','05C8':'Inspect and clear object flag bit $20 when active.','05F6':'Guard on RAM $207C and update game service counters.','0627':'Decrement pointed timer if positive and advance game state.','063A':'Check RAM $207D, then operate on render mode at $2031.','06B1':'Increment RAM $207F and update related state.','0FF4':'Read width/height bytes from HL and set up source/destination.','0FF9':'Copy C bytes per row, advance destination by $20 per row.','121A':'Visit object field at RAM $2085 with game-state parameters.','122B':'OR register B into RAM $2080.','124E':'Process object pairs $2040/$204F and $205E/$206D.','125D':'Test two linked object records before update.','127E':'Advance through object fields and test record state.','13A6':'Mask object status low three bits and compare with five.','145A':'Write object byte, then lookup associated table values.','147C':'Read and compare RAM $2009 against three.','14A0':'Use object shape lookup to update corresponding field.','188C':'Inspect pointed objects sign and bit $02.','18A9':'Increment RAM score at $200A with DAA decimal adjust.','18B6':'Limit RAM $2014 to a maximum of three before continuing.','19F6':'Compare two-byte record at BC against HL.','1E11':'Detect changes in input-port $02 bit $40 and update RAM $2016.'}
DATA_REGIONS = [[15,16,'unused IRQ vector byte'],[23,24,'unused IRQ vector byte'],[289,306,'ROM checksum reference bytes'],[451,455,'diagnostic bit masks and constants'],[616,627,'display test bit-step and glyph lookup'],[648,1028,'8-bit digit and alphabet glyph bitmap rows'],[1275,1351,'position/screen-offset lookup bytes'],[1756,3937,'packed gun target / shape bitmap and drawing data'],[4270,4418,'object descriptor and movement-sequence bytes'],[5307,5379,'frame state, object and sound/pattern lookup bytes'],[5476,5504,'native object/motion pointer table'],[5504,5683,'object, motion and sprite command data'],[5683,5872,'ROM script and adjacent scene-data structures'],[6428,6454,'screen coordinates and packed drawing parameters'],[6501,6519,'sprite source and video destination pointer pairs'],[6655,6662,'difficulty thresholds and selection bytes'],[6703,6752,'screen coordinate and text offsets'],[6752,7202,'high-bit-terminated screen message and token data'],[7759,8192,'ROM padding filled with $FF']]
DATA_BOUNDARIES = tuple(sorted(set([x for lo,hi,_ in DATA_REGIONS for x in (lo,hi)])))
def glyph_pixels(raw):
    return " | glyph 8px: " + " / ".join("".join("#" if b & (0x80 >> bit) else "." for bit in range(8)) for b in raw[:4])
def data_role(pc):
    for lo,hi,role in DATA_REGIONS:
        if lo <= pc < hi: return role
    return "non-executable ROM data; consumer still to be traced"
def symbolic_instruction(inst):
    m = re.match(r"^(JP|CALL)(?: ([A-Z]+),| )\$([0-9A-F]{4})$", inst)
    if not m: return inst
    name = SEMANTIC_LABELS.get(m.group(3))
    return m.group(1) + (" "+m.group(2)+"," if m.group(2) else " ") + name if name else inst

def main():
    args=argparse.ArgumentParser()
    args.add_argument("game",choices=CFG.keys())
    game=args.parse_args().game
    archive,names,size=CFG[game]
    with zipfile.ZipFile(ROOT/"roms"/"original"/archive) as z:
        parts=[z.read(n) for n in names]
    assert all(len(p)==size for p in parts)
    mem=b"".join(parts);digest=hashlib.sha256(mem).hexdigest()
    vectors=[mem[3937+2*i]|mem[3937+2*i+1]<<8 for i in range(13)]
    assert all(v<len(mem) for v in vectors),vectors
    code,owned,entries,edges=recover(mem,(0,8,16,4560,0x01D0,0x11C3,0x1DE9,*vectors))
    word_scan=audit(ROOT,game)
    word_names=["FRAME_HANDOFF","DRAW_MODE_A","SET_RAM_2031","SET_MODE_AND_PTR","BRANCH_SCRIPT","STORE_BYTE","CLEAR_DISPLAY","INIT_DESCRIPTOR","DRAW_AND_BRANCH","DRAW_MODE_B","CLEAR_FLAG_BIT3","RESET_ROUND","DRAW_PACKET"]
    word_aliases={}
    for index,address in enumerate(vectors):
        if game=="desertgun" and index==0:continue # zero goes directly to scheduler
        word_aliases.setdefault(address,[]).append(index)
    typed_rom_vectors={}
    for i in range(13):
        address=0xF61+2*i
        target=int.from_bytes(mem[address:address+2],"little")
        assert target<len(mem), ("bad native/script pointer",address,target)
        assert address not in typed_rom_vectors, ("overlapping vector",address)
        typed_rom_vectors[address]=("GAME_WORD",i,target)
    packet_begins={int(x["pc"],16):x for x in word_scan["unique_packets"]}
    packet_owner={}
    for start,p in packet_begins.items():
        for pos in range(start,start+p["length"]):
            assert pos not in packet_owner, ("overlapping packet",pos)
            packet_owner[pos]=start
    overlapping=sorted(set(packet_owner)&set(owned))
    assert not overlapping, ("Native code overlaps decoded bytecode",overlapping[:20])
    signatures=[]
    dispatch_tail=bytes.fromhex("07 4F 06 00 09 7E 23 66 6F E9")
    for i in range(len(mem)-len(dispatch_tail)):
        if mem[i:i+len(dispatch_tail)]==dispatch_tail:
            base=(mem[i-2]|mem[i-1]<<8) if mem[i-3]==0x21 else None
            signatures.append({"tail":i,"vector_base":base})
    (ROOT/"src").mkdir(exist_ok=True);(ROOT/"docs").mkdir(exist_ok=True)
    asm=["; Original "+game+" Intel 8080 ROM, source reconstructed from original bytes.",
         "; Native instruction mnemonics are executable; uncertain regions retain DB.",
         "; Original byte offsets are preserved; zmac v1.3 must rebuild exactly."]
    for part,name in enumerate(names):
        lo=part*size;hi=lo+size
        # $17FF JP $0132 straddles two 2 KB chips. Its bytes are owned by that
        # one instruction, emitted from the preceding ROM device.
        if lo==0x1800: lo=0x1802
        asm.extend(["",f"        ORG ${lo:04X}",f"; Device {name}, SHA1 {hashlib.sha1(parts[part]).hexdigest()}"])
        pc=lo
        while pc<hi:
            if pc in typed_rom_vectors:
                kind,index,target=typed_rom_vectors[pc]
                assert pc not in code and pc not in packet_owner, ("vector overlaps executable or script",pc)
                asm.append(f"ROM_{kind}_{index:02X}:")
                asm.append("        DW $"+format(target,"04X")+f" ; {kind} pointer from ROM $"+format(pc,"04X"))
                pc+=2
                continue
            if f"{pc:04X}" in DATA_LABELS and pc not in code:
                asm.append(DATA_LABELS[f"{pc:04X}"]+":")
            if f"{pc:04X}" in TYPED_POINTER_TABLES:
                count,role = TYPED_POINTER_TABLES[f"{pc:04X}"]
                assert not any(pc <= p < pc + 2*count for p in code), ("data/code collision",pc)
                for i in range(count):
                    at=pc+2*i
                    v=int.from_bytes(mem[at:at+2],"little")
                    asm.append(f"        DW ${v:04X} ; ROM ${at:04X} {role}")
                pc+=2*count
                continue
            if pc in packet_begins:
                pkt=packet_begins[pc]
                opcode=int(pkt["opcode"],16)
                name=WORD_NAMES[opcode]
                operand=mem[pc+1:pc+pkt["length"]]
                asm.append(f"CMD_{pc:04X}_{name}:")
                asm.append(f"        DB $"+format(opcode,"02X")+f" ; {name}")
                formats={1:"B",2:"B",3:"BW",4:"W",5:"BW",8:"WW",9:"B",10:"W",12:"BWW"}
                spec=formats.get(opcode,"")
                if sum(1 if x=="B" else 2 for x in spec)!=len(operand):
                    raise AssertionError(("incorrect word format",pc,opcode,len(operand),spec))
                n=0
                for field in spec:
                    width=1 if field=="B" else 2
                    value=int.from_bytes(operand[n:n+width],"little")
                    asm.append("        "+("DB $" if width==1 else "DW $")+format(value,"02X" if width==1 else "04X")+f" ; inline {field}")
                    n+=width
                pc+=pkt["length"]
                continue
            if pc in entries and pc in code:
                label=SEMANTIC_LABELS.get(f"{pc:04X}",f"FLOW_{pc:04X}")
                if f"{pc:04X}" in FUNCTION_NOTES: asm.append("; "+FUNCTION_NOTES[f"{pc:04X}"])
                for index in word_aliases.get(pc,[]):
                    asm.append(f"NATIVE_WORD_{index:02X}_{word_names[index]}:")
                if game=="desertgun" and pc==0x11EA:
                    asm.append("WORD_ZERO_FRAME_SCHEDULER:")
                asm.append(label+":")
            if pc in code and pc+code[pc][1]<=len(mem):
                inst,n,_,_=code[pc]
                raw=mem[pc:pc+n].hex(" ").upper()
                asm.append(f"        {symbolic_instruction(inst)}  ; ROM ${pc:04X}: {raw}")
                pc+=n
            else:
                # Preserve all unclassified bytes, never misidentify as native code.
                stop=min(hi,pc+12)
                stop=min([stop]+[b for b in DATA_BOUNDARIES if pc < b < stop])
                for p in range(pc+1,stop):
                    if p in code or p in entries or p in packet_begins or p in typed_rom_vectors or (packet_owner.get(p)!=packet_owner.get(pc)):stop=p;break
                raw=mem[pc:stop]
                category=("bytecode word "+packet_begins[packet_owner[pc]]["opcode"] if pc in packet_owner else
                          "native command/event vectors" if game=="gunfight" and 0x09AE<=pc<0x09EA else
                          "native command vectors" if game=="desertgun" and 0x0F61<=pc<0x0F7B else
                          data_role(pc))
                asm.append("        DB "+",".join(f"${b:02X}" for b in raw)+f" ; ROM ${pc:04X} {category}"+(glyph_pixels(raw) if 0x0288 <= pc < 0x0404 else ""))
                pc=stop
    # Generated recovery drafts never overwrite the maintained hand-edited ASM.
    review_dir = ROOT / "build" / "recovery"
    review_dir.mkdir(parents=True, exist_ok=True)
    (review_dir / (game + ".asm")).write_text("\n".join(asm) + "\n")
    report={"game":game,"cpu":"Intel 8080","rom_size":len(mem),"sha256":digest,
            "devices":[{"name":n,"base":i*size,"size":size,"sha1":hashlib.sha1(p).hexdigest()}
                       for i,(n,p) in enumerate(zip(names,parts))],
            "native_instruction_count":len(code),"native_byte_count":len(owned),
            "edges":edges,"indexed_dispatch_signatures":signatures,
            "extra_re_roots":[0x01D0,0x11C3,0x1DE9],
            "cross_bank_instruction":{"address":0x17FF,"bytes":"C3 32 01","native_target":0x0132},
            "revision":"v20261031-0001"}
    report.update({"script_pointer_ram":0x2000,"dispatcher":4560,"vector_table":3937,"vector_count":13,"vectors":vectors,"initial_script":5683,"decoded_script_sites":word_scan["distinct_packet_count"]})
    (review_dir/"recovery.json").write_text(json.dumps(report,indent=2)+"\n")
    print(game,"native 8080 instructions",len(code),"code bytes",len(owned),
          "indexed dispatches",signatures)
if __name__=="__main__":main()
