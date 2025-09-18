data segment byte
 temp dw ?
 temp2 dw ?
data ends

CODE segment byte public
assume cs:CODE, ds:data
 extrn talk : far
public write_me
write_me proc near
  push bp
  mov bp,sp
  les di,dword ptr [bp+6]
  mov ax,8
  push ax
  push di
  push es
  call talk
  mov sp,bp
  pop bp
  ret 4
write_me endp

CODE ends
end


