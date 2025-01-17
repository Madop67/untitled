GetItemPrice::
; Stores item's price as BCD at hItemPrice (3 bytes)
; Input: [wcf91] = item id
	ldh a, [hLoadedROMBank]
	push af
	ld a, [wListMenuID]
	cp MOVESLISTMENU
	ld a, BANK(ItemPrices)
	jr nz, .ok
	ld a, $f ; hardcoded Bank
.ok
	call BankswitchCommon
	ld hl, wItemPrices
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wcf91] ; a contains item id
	cp TM01
	jr nc, .getTMPrice
	ld bc, $3
.loop
	add hl, bc
	dec a
	jr nz, .loop
	dec hl
	ld a, [hld]
	ldh [hItemPrice + 2], a
	ld a, [hld]
	ldh [hItemPrice + 1], a
	ld a, [hl]
	ldh [hItemPrice], a
	jr .done
.getTMPrice
	ld a, BANK(GetMachinePrice)
	call BankswitchCommon
	call GetMachinePrice
.done
	ld de, hItemPrice
	pop af
	call BankswitchCommon
	ret
