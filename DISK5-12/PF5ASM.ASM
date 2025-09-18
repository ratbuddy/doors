data segment byte
 temp dw ?
 temp2 dw ?
 extrn usernum:word
data ends

CODE segment byte public
assume cs:CODE, ds:data
 extrn do_name : near
 extrn do_amounts: near
 extrn do_smokes: near
public draw_all
public determine_active
draw_all proc near
  push bp
  mov bp,sp
mov cx,4
loop_top:
  mov ax,5
  sub ax,cx
  mov temp,cx
  mov temp2,ax
  push temp2
  call do_name
  push temp2
  call do_amounts
  push temp2
  call do_smokes
  mov cx,temp
loop loop_top
  mov sp,bp
  pop bp
  ret
draw_all endp

determine_active proc near
push bp
mov bp,sp
mov cx,4
mov bx,usernum
looper:
 mov si,cx
 shl si,1
 inc si
 inc si
 cmp bx,[bp+si]
 je okay
 loop looper
okay:
 mov ax,cx
 mov sp,bp
 pop bp
 ret 8
determine_active endp
CODE ends
end




;procedure draw_all;
;var x:byte;
;begin
;for x:=1 to 4 do begin
;  do_name(x);
;  do_amounts(x);
;  do_smokes(x);
;end;
;end;
