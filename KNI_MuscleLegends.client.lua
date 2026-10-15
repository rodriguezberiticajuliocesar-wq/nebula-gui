--[[
    HonenxWhite | Reborn
    Hub completo para Muscle Legends usando KNI_UI
    Made by Honen / cyanam1 / White
    Versión corregida desde 0
]]

-- Fondo incluido dentro del propio script (foto proporcionada por el usuario).
-- En ejecutores compatibles, se reconstruye como archivo local y se aplica con getcustomasset.
local KNI_BACKGROUND_BASE64 = [=[
/9j/4AAQSkZJRgABAQEASABIAAD/4QBiRXhpZgAATU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAAIT
AAMAAAABAAEAAAAAAAAAAABIAAAAAQAAAEgAAAAB/9sAQwAGBAUGBQQGBgUGBwcGCAoQCgoJCQoUDg8MEBcUGBgXFBYWGh0lHxobIxwWFiAsICMmJykqKRkf
LTAtKDAlKCko/9sAQwEHBwcKCAoTCgoTKBoWGigoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgo/8IAEQgDpQLgAwEi
AAIRAQMRAf/EABsAAQEAAwEBAQAAAAAAAAAAAAABAgQFAwYH/8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEAMQAAAB/K4AACygAAABYAWQXPAe+OEG
NhfTy9DPx2vE87lTzekMJliMscjc8bmY43EeNhClBQXFSrgZMaSZQi0xbnmazIRaRRkuBjAAAAAAAAAAAAAAqUAAQBQCWUlAgsBljT0mAySlYhEFlMssKAYr
CWUWDJjkMsaXDMeeUoiGeIbDWplipLKLKXzQAAAAAAAAAAAAAAAWCpQAAAsIoiiLSWDJKZSCAiwijL18KejCkwyhKhbBliDJkXHGDLGiqTH1h5UKoGJljAAA
AAAAAAAAAAAAAAABQCiWCUWykKQCZQWUkojLEyxAlJlcS1TGyFxDLLH3PJt4Hhk8yAoGUxM8csSSwyjEsAAAAAAAAAAAAAAAAAAACpQCwAAKxpYoWBBQWWEU
YqAFmZgsJQuWIzAxyxBDLFCxDJAWCWAAAAAAAAAAAAAAAAAAAAAFSlAlEAAsFenqaywEMopCFxollFgEFgoLlh6EMRQgICmRMcsAAAAAAAAAAAAAAAAAAAAA
AAACoKlFgyxsMsvMLABllgLLBFJKIAAehgoiwWUtxHp52AFywzJ554AAAAAAAAAAAAAAAAAAAAAAAAAAFSgACzaJi8S45CM4Se3kWWnm9oeN9KeVyGFzp5qM
ayJM8CWAC2UmNgAAAAAAAAAAAAAAAAAAAAAAAAAABkmRjUHp5hZT0bFNZ5jf8taG9jqQ2vfm03fXmU3MtGG3NWgEtxACwWUsQQAAAAAAAAAAAAAAAAAAAAAA
AAAAALlhmJRiAQqBYKgqCwAAAKgyuAzYjLEACAUSiLAAAAsAAAAAAAAAAAAAAAAAAACiAWDOYgCyiKIAUlAgqULCKIogAAKgAWUJRKIsAAAAAAAAAAAAAAAA
AAAAAKABLAABYLAqUAmUACUAVAKQAEUQAACygAhYpAAAAAAAAAAAAAAAAAAAAKAAgAAAWCyigQWAAAAAyxFmWIAABFgAsCygAhZYAAAAAAAAAAAAAAAAAACg
EWAAAAAoqAAAhbiKQWUAAtmZ5ssQAAACAWUAAASiAWAAAAAAAAAAAAAAACgAgAAABRljRAAAAlAAAAUZXEY2AAAACUQCwUAAEWACwWWAAAAAAAAAAAACygCA
AAAKAAGWR5gAAAAAAemGRl5ZYgAAAAACWACygAEUQAFlEAAAAAAAAoQAACwVKRRACgAACgymRhLAAAAABZmZ4XAQAAAAAAAEsAKlAAIsAKCAAAAAAAAoIAAU
lAABAUAAC0Si5+XoYY5QgAAALKM80Hj6YEAAAAAAAABAAVKAJYALKJRAAAAAAAUEABQAAJYLKAAAWKSoZWUzx9IeWOeJChYFyMfSUMvMximKwAAAAAAAASiA
AqCyiLBZQCLAAAAAACggAAFlCCygABAoFQAZ4ZHp6eHueOGUJWRn57I1vbOFwZHlgggQAAAAAAAAACWAACykWCwUCZYgAAAAAAAAAAACygAgKAWAAyguzq+h
jjYZet9jMhfLLzNfJgEApisAAAAAAAAAEsABSUAIAAAAAAAAAAAAAABQASwUAAALLC547R5ee54GzPOF8/OGUxFxoSwKJKIsAAAAAAAAAEsFgoAEsAAAAAAA
AABSUIsABQACWUAAAAoHa4v2BwvHr8kupsa5gQssAACwFIsIsAAAAAAAAEsABQBLAAAAAAAAABZQACAWUAAAAAAssLKMvrflvsDR430PBNfW9vESgCKIoXEZ
MvMyxzxEzhgsAAAAAAAAIABYLKIAAAAAAAABQAASiUAEsKAAACglDZ+5+K/TDkfO/b/KHzPn0+YQAAAEULBMoPXHDaNfDIYLAAAAAAACAAFAIAAAAAAAACgA
AAAEFlAAAAKQtmZvfsX5H+vHP+d7eR8V8t+i/BmqsCwAAAAz88oM8KbmluZnPe/kYAAAAAAASwAUAIAAAAAAAABYFlAAAEsFlAAAALFHv4e52/1r8l/bT5Dp
7GB8f8d+h8U+BmUEogAABSFF9d01vpOb3zjcj7PinzeOzrklgAAAAAlgAsoBAAAAAAAAAAUAAACWCgoQAACyjb1O6e37p+afpRfnvpuaa/C+08T8D5X7r+On
OybpzXU5hGfqa93escKffdE+B3ftPc5Xr49M8dr531PXle2mcXn9TRNaZYkAAAAAlEAsoAlgAAAAAAAAWFAAAAABcsczzAAAspf0L4H7E+0+t+C+oO1p6fsd
SamyZ/NfR0/Oer9lD5f5v9I0T823+ttGvr9f5szw4/kdHHU9zf8ATnYGfO2cDy5eXgeOt7eJr+Xt4gAAAAAEAsoAlgAAAAAAABZYUAAAAAFuNIAACg2fpvm/
tD38+v5nP29XzPpej8Tvn2238t1zs5aWwTS3Oacjc1OUTgbXmY7O39IcXqd71PnPL6bTPmeR9D88crhbnNMM9jwNbyyxEsAAAAAIBZQBLAAAAAAAACgAAAAA
AAAAAUOt+t/kP7KdnPD1OXzvpcz4PU+65J8729XYO5t6XQPLm9fTPneT2OKePRvVMu5855H2OX55qH6P8t8J8ofbfLTunC2tPcPbQ6XKNGAlgAAAABALKEol
EAAAAAAABUoAAAAAAAAAKLKbn3v57kft+x+Cex+/Zfh/WP2DH8p7J9Z4b1MetzeuTR6egfNczuah58/6HcPynT/YeKfBef6JpHzHSx5Z0/m/qOgfOc77Lkny
3J6fHMQJYAAAAAQCwLKAQAAAAAAACwUAAAAAAAACyiym13uR3D6Lb5PROx5+neNHuenqa/nt+BqdHT3TPR39U42vu+Bt7utvnn5bmJq4buZxPLu+Rxp0dQ5P
yH03w58/oe/gQApi63LMQAAAQACyggAAAAAAAKAAAAAAAAAChKLKfV/Tc/vHZ6On1TZ9LkWqY6+z4Gvva2wZ+Pt5nN19jXNzd09wzlEsE8/TwNflb/BOJ8R3
vlzR8ssQQA9sMAAAAAlgWCwAAAAAAAACgAAAAAAADP36Zw5YLKLKfo30vw/2B9B0eL2De9PLI9GORPL2xNPb8fQ9vL08jla/t5G7vcvoGxcaYMYXWz0zT+U7
PyRyOD1OIeUsAMsfTEwUQAAAEKJYAAAAAAAAAAUAABBQJQAMjb18MQBZRYO99j+ffZH1/wBD8f8AQH0N1/U9mNLMcAw9D2888DjYenkTpcnonQvnTHC6w5m3
xzkfN9bgHH5mzqCIALKEpAAAAQFikAAAAAAAAAAsoAAlhQEoSiwALMhPTzJZT1+j+Y6B+gd75L6Q+s2dPcPTKCa+1pj1+a7B2MccTkaXt8gdn6D8W/bzdxYG
Ol788nI2+Ccr57p/Omp45YiWAAAAAAAEAAAAAAAAAAAABUFSiBUoBKApALBUAF2dan0v2H5z9Wfo/U+Z+gN7LyzMsch+faP6V+Yn2fn+Q0+q+Cx+hPof0vnb
JseGGBjo7nMNH5/e+fOdw/bVMQQFgAAAAAAQAAAAAAAAAAAAApLKQCygCyihIAAAFSmfT5Pofov135h9WfebPzPRO05fgdnw4nIOF8N+p+h8D+rfM/PH6J6/
lHofqN/Mt4+05Wjrnh81u8A8/OwSwAAAAAAAAgCiLAAAAAAAAAABYAAFgsoAAAAAAWCg2fpvkemfe7fynRN/h/Q88+c0fpfI4LpaJqeXR3zi722PTr8Tom7y
8uOanOz8gQsAAAAAAAABLAAAAAAAAAAAAAAAAUAAAAAAAAWUZYjsdn5TvHb8fL1Nfc5fidf14ukb+Gj6Hn4b26au57jT4vU4JjAQAAAAAAAAAAAEsAAAAAAA
AAAAAALLCpQAAAAAABYKlG7pD6vvfCfWn1F29s5Ht390+Z8/rB8drfZcI+Z5HV+PNLSsEsAAAAAAAAAAAAEsAAAAAAAAAAAAAAAKAAAAAAAACpRvaI+5+u/H
+4fr+/8AnnYPsPP5vVO/8TofPmz87fEEAAAAAAAABCgAAASwAAAAAAAAAAAAAFIsFlAAAAAAAAKlCC2Db3OQOxr88e3lAIWAAAAAAAAAgAWAsAApAAAAAAAA
AAAVKRRLKQCwUAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAABQJYAALBQAAAAAAAAAAAAAAAAAAAAAQAFlgAAAAAAAAAAAAAAAAAsFgAAVKAAAAAAA
AAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAABYAVKAAAAAAAAAAAAAAAAAAJYAAAAAAAAAAAAAAAAAAAAAAAAAAAVKAAAAAAAAAAAAAAAACFgAALKRYAAAA
AAAAAAAAAAAAAAAAAAAAVKAAAAAAAAAAAAAAIAABYAAAAAAAAAAAAAAAAAAAAAAAAAAALBUFSgAAAAAAAAABBYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAolEW
AAFgVKAAAAAAEFgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAEUQACygAACWAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACygAAEAAoAAJYAAAAAAAFEWAA
AAAAAAAAAAAAAAAAAAAAAAAAACwVKAARYLBUoAAIAAAAAAALKJYAAAAAAAAAAAAAAAAAAAAAAAAAAAAALBQAICwUACUQAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAFQAAUAACWAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFQVBYAAAAAAAAAAAAAAFlgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAABYAAAAAAAH/xAA0EAACAgECBQIFBAEDBQEAAAABAgADBBESBRAhMWATIBQiMEFQIzIzQAYVQnAkNDVDkLD/2gAIAQEAAQUC/rjkfYIw+iIf2jlr
tLtr4aJ9j9ATXXlrG+kPopXujpt+gfyQmvt192v9Wt9sdt3/ABENOZ9oh8f0+gfDBDyHLTnrD+cH9oQRQDH09+niQ5bp39+vigGs7EnxoTv4Kg1Lrt/rCHwQ
HSM2vvP9Q+4+GgfXP54LD7dOQh8SQdGb3bWjAg6EAq02fIEJAUmbGgUmBSZtOhQiCHkIfBdeYXWEacl/ce57npLOkI/T/wB//rP7l/jB1L/x2nQ+GVsBLGB5
68teevPX/wCzx/4208b7QnXwrSfb62nI+NfY+NDwswT7kw/UA5N4T9z/AEBD38OA6/S0gh7eHLNIfeBCIO328PBn+w+xRzrjdQw69vER25iIOhTRdOg6QHVi
eviKnpyEr6Fh+mvz8m/b4mOaiKs7pX2LdSdQ3fxNxoBK+pWA/N2mvQHxTHr9R7B+n/tUFZuh7+LYIMK/IvRbCIPGOGjdhZY0WPNfm8WE4UdlmTp6E7r9QdCe
h8JUShdpyk2hx0+oOXcQ+EJ3RG9DJGtOzWpxtf6h5r+5htbuPBaBq4r/AOhZA9OzWvKQlf6A/UXt4KJi9bKawaqx8mVWarjU2n1e/NToXTUeCLMRdXxztW/5
LctQ+Jk7fTyABd/QpYg217Tsh8CQTh3/AHdadOJAVvg7bakUpM2g1n6wmkp70j1KGql1ZU+AqOnCP/IIJxmrfgYgJnEa2pyOJ1F8f62zWV1bqlo1lIOy1JfX
ulibW8ArGs4areuoEsG5OFWE4nFKxZTdQwws3HspvinQlevuRN0KESjFNtdOEyinBQPbgCk14tZFiIqtpttl/c+AYya43DMX9WofIe2NUtZKfpemJxLhqZIy
8V6HC6yhCbL8Yo00MWp2HwziDh5+Hw8ILHw6/Tx6gss2bfjlak5l+yyzJqgudqtzCMwYWmMIfz/BaBbg8NrKLV0Q9iNB9l6CcQ4auQMfgoEr4WszeHC2W8EX
SrB9OUUCqfChqLKq9CxrVszSPlNZNm6V/JHKlfsy+md+6WtD+0w/lft9BR14ZbdXBmitaMyu2HJXSqwFarBpuE15aCaRuzGZP8tNW0v2axEay0ltN0C6BOk+
bTUwtqWEI2EsIx1gj9/ztP7sQ6E2azZDuEqy9gqvDFLolsDQTWExzGX1rd+xcrILx+rKNSqda8RmiYek+DEbGCr6CgXoN1wlugI6zSP3/O0KWsxcV2PwTLHx
WWNUysEBAQqa7OtTxG1iGawzI/YdUS+w7fsEYyjHO6jH2xVmk2yzve2+WECZV8CloP2sCI3f87hfy4FYAVYV1hx1IbDXa9RENZ1TUGlpWZrDLescfqZGhIWV
VygDcqDQLNNISNMzNqByeKVyzJsslCrNNx0lv5/E03YqgKpMZ/lA6bZYimW44npysaSmARhrLFl2gYKd1S6xUGlh2yziNePD/kdSyz/JgVyP8gyrDZY9jY2J
ZeTTXiI6nWt/k6aX9/z1Vm1cXii6U8RpMty6GjZAWfFVwWI8Kgh6QYU2ymKJpLRLh129VGi5d/oLe3EMlauEZF0fgGUoHA8kyr/HLSP9LxsQ5mdjpi+jY5FI
2PTsJ2mWHU/nlrLT0rJ6dhi0Xkpw7MtNHA8wxODZ+7Ex+KY7orFNusrXRl5XdnE2fMlUFIjpGWwP8VkotnELTHzrp6N+VZRgIjWU9Uo2jJABytBD+fpJBx7k
LUfDxLaouTUka+26ynGs1SsKNsIg7ryuEsEA61CaTSFZshpEagT0AAKQIyAG7TTLbrkHVvz+PXrK8fcxw2Za8DdMXhqhlxgCByMeCDlZLB82nWqDlpzIhEIj
zMYaZbxz7RBjh6yND+Y4bVvAq2SpeqL1RensaL3HJuzjr90g9phjS5pnWTIaN7lsZYTr+Z4QNE06Yv8AFWIPaZ9xyMti90g9zR5lvoMp5dD+ZA9wnDDpNoda
PlRDrB7TOuq8nlsHeqD2kxjLWmW8yDLj19mn5THq9WzNRaV9omA/y4rakPo9LctPYZ915P2t7ys6RTzPIx2mRZMhtTkGP7VMP5Op/TFjl292G/TDs0Ou6Udv
c0Xk/az9wjHQV9uTTWMZa3TJaWmXHUt+YEP0KG0eg6hLiKcSzcoPt1hi8mlw66y09KP4+TTWMZkHSXtLj0sP57T2J3w7pW3y4R6JBBzPRi0rPJu2R3L6TKyF
SrAO7G5ExjHaXsNL2mQ8b86IT7a20OPZuXCPSswezK19GrLS0UPrAYxmQeuTnLXLMi3LtxU9OiGNHPW4y9pc0vbU+B1HrhvsbEs+ahtQpg9nGMB63weJbpVm
KVtzUnEOIaI7lz/jmB1EJm6MZYZc/S95kWaRj4LW8xLeuLZrK2g9jCcc4fsNeZZXHzSZY5c8GwDk3VAVqGhMEeXNoL2lzy1tT4Kp0mLdtfGulFvRbIDy1hjq
rLxXgxUtW4PD+G2ZL0VV49XxCwXLDeuvrCWXy62XWS94T4OpmNb0xrolpld09bSNkgR+IIgs4rP9U1nxGMwu4gqS/NssPrlIOINF4kBKs17IthMtfpfZHbwm
ptDj2ym+G4yzIv0svvj5LaHIefEdPXjXQB2IpYlcdYiKJUi6HpLnlz6k+FUWyuyI5MVhtsMIm2NQpjYwiUqCoAhIm4RX1Is6PZL7Ix6+FCUPK3geWNBZFBKD
qXStVZl1NojWTcTKl0nWMZafDa22ms6hRqBWxluN1Wq8FnyK4xyLp8NfPhbouI0XHgr0jDSXNoGOp8Not2mp5SwIrxQy/DCfCgxcJZ8IBDiAw4Usx9oZdJe2
kyLNx8Px7thxbVDU3KUTRhWgECiaTpHmSwEyrZlW+JUXFJiZXTGvDCuyB9ZrNZkWbRlZHXIujtuPiVdjJMbLMx8/aF4gk+PSXcTAmTnM8tvjuW8WS4rBlw5c
OSxjWMf/AMvT/8QAFBEBAAAAAAAAAAAAAAAAAAAAsP/aAAgBAwEBPwEpr//EABQRAQAAAAAAAAAAAAAAAAAAALD/2gAIAQIBAT8BKa//xAA8EAABAwICCQID
BAgHAAAAAAABAAIRITEDYBASICIyQVFhcTCBBECRI0JSYhQzUHKgodHwNHCCkrCxwf/aAAgBAQAGPwL+GKsqqdEqY0WVNAOUQnpidNigR4QXaE7yj4VLynJi
pz/jIj/l6dicslHTXKR2yFHTLNNE9lKplQaPA0HK5HZeNPvljW9k+VHfQcsYo5gypFnMDv8AxHspyy5p4XNVLMJYh3Cg5YasB3aFj9KoRz+RkZIaFhlPMf2U
D+FyI+Q7HJH1XcAFY7PySnjqJ/qsPFjiEHyPkfzZHI+i1e0LeuWOb9EwgbutJ8G6+IwD+83yPktYZGE/iVTTkViieEyPcJz/AMEOWI4ceHBnt/cJ2rw3HyPZ
TyKORMMfnXbomuqWlsEJ2GRG7qkJofzBwXr+XyPdOBXdVyHgz+LQ5wFWbywSROvh3CxX8WGYc7sjIh4qfkI5qi1YgzK6HIjNUVFVKcDaE0O48JxafZTE0hYc
ybNcsVr+R0n0KhO7c0zEcJbrargi11WOqwrWYCWoOZUFQRPfooP165DxnxyhNPR31kJvjQ8j7511CEVaUHRvAavkKCEUxrxQ0ToHfTIaShrCAeaZiSDK1XCW
8iogIi1EQ4w2EGsl7qCg5r/DCO5TnM1RNS0LjaZ5rqibZCc11nOTSeRagCimv/DTRGgxdC24S0pwIpUJrm8QosUjyO3ZOafvLVIUQJmVwyhqunsVvQ1fZQ0D
m5DXcXnuhEBQSuy1m8HMKipkINEQFrOY9ku5juow3A+Ed5QvG3Coi5+q48qKoCh1ekLd+q3qqlEZ3ekK6tAUTopb/pVGQR5RhXCsgFD5hbpur7XZHU4RdyHL
ujBp0UzsXU80eak37rVaFdVyC0BERp5+6hHVW9tFRPso0VKgqysqaY5LdUArWerZAYgTfRUNRNBOiCFyC5bMIKFZVUbHdFuv9FDbKilxk9FXIImybq/y0SEN
FlIUHasjouqFb+L7LhJW7hmVuarB4UvMroO6mhK1wFJ+qpkAhNqhWqa0PhxPJbz2n3V1Rw+uiR6AAUlpJ7LcwnNapmqH9NAL3t8L7Z1UMD4fCnEKnEQRcz3C
mxyDQLgct3DeuA/6ipDw33X65n+5XwntHKUC6jkZ9CwVk5zGkFbzVRoVC4eyl7nAd1Qe6tooqZAot4IHX1T3XFM1XIlAN3B4W/ZU9awVkd3YOQZUkKldBc6y
p8rRHbkH9tz3Tewn5inoUNP21VO6IHrloKnEVEWylHJBovthN7BedFsoSpdtwgg4ePXG0cijQWoes3Jkc/Xc7osMnptnIochtnVuFum1x02Lo1lBgsTZMb0G
TdX0D8T8IYd94Bb1HaLow6vLR+kYg/dycDz9E42A2nMLqrVVVrPH2YQDbZQvtwbJz/h6jooLHT4QLhq4fUoNbQBXV1fRTJgV9ipVSqNoqtUmJUYcKDifRcaq
VzlWIyhRbtVvMp2R3SqrnOmgVSqq2T4O1ZWyxdSrrWBHjRLlTK9lumFRy4Z7qCCrKqrlODbTLlTRZWVsq1sgeSp6FFGUoNtu6Oicp0V1XRdbqqf+NQ//xAAt
EAEAAgIBAgYCAQQDAQEAAAABABEhMUEQUSAwYGFxgVCRoUCxwdHh8PGgcP/aAAgBAQABPyHxnmnVRb3KR6ENsp614tukHoZvjoSpcuXLlx8uuhGP42/DwwId
ElR67TBNTXofAdBj0HR8RKkZSpXVh0f5JV0X1GPhXL9LfCdDqRI+HjovQl8JFj+YfJqPh1Lly4RJzCPS4NRfIX8oHSo+MYoal4i8kJdRfBUSJ47j+OqV5FxZ
fgep1YFyq6HgCaS+p0PIX+LPAda8moRfCMubjFF1VcYqHRt4TUej1uX+RL5j4CVjodHPhUCbyERqvFpCcfmBj4Rj5N+SuCJbCJ4XqvwP5l84MR8B4IWeC/RT
4b8aroSo+U/mTzQ/EC4489VFfWvER/LkToixF38NQm39FcGDHgPzS/IzLnHl4I78gY9SX+eBbMdsqaj1qHQfHuvNOj+dLJnGTfUJVtEQMxQBExGJSVNQX/bU
orCDWHtEhyxGcJbUamoYdQJU1B4B+hCXDoRoXaXP5EL9M+nMVfYibQqo7HfMzV1D3y/dFzzdd+QgVN1NLGGJYsCXHyDo/mTxk3k1kvorop2selmsuJcuCNMv
wBE9BHk3/QXL6VK9AH9Xcv0AMuX/APoR6mr0i+UQ9O8ek0x5JK9E6/oiGqgTZ6HI/wBER1La9MhmNIlbidvTBBeyUvfmPonCY+cfO0uBiez0SS8wleablGRF
6JNxbYHeN15wuLxH0TgBzNpcYaPjy3HUOzxAGo+hwthn2R23DBDcKG2OWJ5PHQizDBxxFvMfQ5p6sMTbiak7O8fIcVC4X3qWATZmZdL6I4nHQxCxnPvC+fI2
EYa7RIh0zS/ccdH0OdHqauVEtwOfBJcQE4n9zKJylCloj/E49Ea8BHUO00/qM4nEFzAv9zcjDA3+9kFBreZQ9mVGmNMY49HG5zAHeCiOGuguPbrUptVWX/MD
lguJQ3v9QvzJzF56MM+jOCcw3NY94RrH3md7WTaLV7jyF01XtuE08omEGg/iY30c+AxH0Wb6mmL8GDfxcDu1S2++CV3csvQjDAjzFsPbo6PSBLALBs7PLP5h
dUiN6xDI5q8WcvwGJeOg4T7j7ejqiDGzGOT/AJGZNd2LiKAoMTIHtHfpfEehfr/2W5iK/u/tEXL3TXuf8SmVYvXk11DD7Tj0VtNuxNf9+YAwZA/Ov5P5jpuc
MxyH+fKIckrFx5IcPHHx036I/YYPJ5K/77zKjK33f/kY5Qv7Jdl5vfmO1HnpeF2a6DBo/tN/PofPlXcpHVcR8Obz8CF0w/8AF/qe0T5uWejwmmIwhgIhYehq
v4/sjpSyAYfYP1iWNu6+Npgf5mIr/J39CDDgfzMqtMfQm0FBhRIJ8XEws/8Al1/Zm4hp9H+0rTnN/wBlfUfN09+r3Efnu3SvQezcsWj+mo1BP0X/AFGmWtL/
AKfEdBarTNiZ/iKsWp9yKjlmfo80eoypmVxHp/MRWhk2QHHoK4V7MWBSpuKYmW1DLYG8V/7Bq0VN4q/1BjFoPjBf0/xAV3hV8nW8V5m2dRpBw+vf2lcDR8/M
z67LqUIfcSn0Cjh8THgUuVGXEPNCYduT9MNpxoVOJnVXnI0v8sxXj7DD/h+4ldAu68l6A8S2QYcy6X8JhO1blY+WvF7+pjVMmZRz9TFcRPQFB9i5c7Lf0y/w
R1d0MeKQnfE1UrH/AFxNI6nW0ZZAcirQMf2/tCY2Z7nfpQrrmKEZrnv41DQ3Vkp1AeZZAl8U/ZPm3IHvHK4A/ZLfWGOz/wAwyDnvD2ZWbhjlFiPJI4NQXTcF
bj+VfKyqoFv5l+NQUcBRlUxy+IHJYs/hlSOaySzEqt9pgEUsQQaxeI2LguJx0V99SwwDAd/EqYrpqDBD2jar2S6iB8gDk+ZoCCp/MWL1Y96h6UMjF3FVqZK0
GIVstn9q+8x1N8Y8TCY5wfMsLYaXiHKDABa7PMuxyP1+XjroeMLZwRNjiXRTnFkFW177iNnEINqijuMEYJQ0aiR/wz/7/MxBtbTfJ/EuB/wBpP03+4fVNbuc
wpmWlYXg2Cm4NVO0sQSov2m0NCrHMtBHy/zKup8ymq5jb9ETZ8Y1/EI7PZrEvZWvq5d5NDvzL7YbHNe8QLhrwquYC15dwipMWvy48dwzWcTuxIDuYggQwYtv
7ZcrR5XKcFxwwWEeMwlXGmYNpzKQe82NGdypnliCNm0sWrj/AHLEL+A/cyVT5wRxVTRbl8LfHCaMUd+J2yhBmVZawbGme8u2oBcioSn3i0X5DxFTEPEpYjtf
yweSgsLwj0CVq2ohSocIEpYtF1mmPPIXe5QVuTA9KaNyjdveE8lmJ75Fju+3QSC1895uf/EqteUMX7TAacrMZwtT/aHOVEy3eO4SvxXzKrdr3UXXIT33LQK9
zcL0rZ7JaaMXhAazNmX5YLbalAU/Pm9FbjE9nxKwj+oZb994kAAF3s3OQpnpfa4ZQomJiHP7lIpz8R6FgXUQVbljsEjBRe6aIjJReVMzOD+3cUuzsTBRR2yQ
torAi1OFkU52wlitbjJNBMrDm8pu01xLSz2uGBEV/niDJnJLLhkKuIUCp1i8EAqM9ybbHvCbUaqLNpfaIhbLi9Q05ir/ABUu39lln+2iWlDHMOx27zBYhuxM
lme9EQfOEx8+6Md47ERT3aiNQ1BbRG+46WP54JjghMtRAzHJpO5AEhj2lIVmomszCby87YgEP+I/unyxLj2loqGTMKaGIZrXbUR4nyiYtMMwYL7mFlexJUPn
pwYarKKkpmAnvxeDo+8fZZziVA2tUIKshIsvz5NczOxdBTKG5OLjIpl2yRMPogzBk/Fwj7OE2A+RlwkPn9Ri0XLwWMXDBedS9zmewGZQbRafvh8pMWDzHZGR
yPaNbX2VAkrg+iYEMEndZIVPTutxlAXHMb+BlBH1Ylhn8+RZEi2T2g6rfpjDJN0Mv3HuBN3OyhaUHvaXHUmzMGMTYMdBnnrFmKmzhWFtcQnmWLse6RSkHxUG
AZng+ppV7s0bH5MeNg5LNqHu3OFAGJljcize3oBbv1jI5NagzKGXSUVAXB9VwZZ2ujlKqh3W5lGNEoMOocZrGYpkAlXRF+nLK8lx/wDqm+n2xBBS2e4MsFR5
FyQIW/aP59se4Q7EyC2wY1MG3B7y4h4CwtliNzAgghzD0F/U7CfsmKYhlRgJWIECUX04Do11+FZzN80ZB2fmDccQlY2qsJxciBlRTAMIGYdGZwMa9DAAv4gZ
w56mHgHbC5ZjRYly34xaNbiXbd/mCVAONkRZdpaZZ+TgVBiVDowQIXXj8zh8Aw6PS6sgQuuLMdv5l0usR8OxK7NQM1WscxtkI6xjELWz5IyvAzfGZ3f11KiL
WJzMyjhHUvMvpYJWLMjbL3LMjwlolNfk6j7oyOR4tppHiU53/JHoOFzBUoeEocQJUroYXQwmdy9T0CLNoscxMwMvGbIs+ETcdv5O+G4ma18RKIKx5hijQxoI
eFndMk6nvTtJkDiO6oPRRw6NNUCmuJmZe3Mn8wIvIqGhZrGHwO9x1b6d6g9FqOdR316SjaFJmncjtPaEuaTSd6UpdZK2y9fzpmW14FHJ0l0PUuo8bluei4qx
J3ziZ5bDoYg+4HZFO4EXnxeiwpS7lRmbhzCuMaR/ncZdVY8A0yn+NyzDdwVXu5jCKEToEovMRG5lTOVAOesUq4aFMO8sWwwT2TyXFHPoTDiYZseirn0GWDqZ
w/EtUXLLouqWRU33qaiNCMG2+0IWY13llzMRYFudwuDFBCNut95LbhBLzLm/Qg1MwOExm9wgFwI7g9QRGXxXyXEc2/apYthe8t0kG/3GFVQlmJmzMm45cXLB
zMTLFi3+YPNtRKuGVJFgzcJJeQYwrIyMVip3OyV4Ah4Rb5IB4KU3jV1N6kdWkxbhcpZ8S+5esu/MnnUMvzZmAqDBOJi+yveO2NRqwHKlZlrH8xpj3UmAF8S9
D4wIXqt8sB2IytPhMrU95tenoGXMfRDnmIVmJWYNyqXAPvLa/eSmCfJqUaDAkDhljaFZkRmVjF7QqUX5mvMRYIwzdMBc29EjTKodpjVXMVzAtqBKU2fmopbB
W81NWt94JqA9p7xC3fUoGZhwzhlnosqYybmroMdISDSW4SDjScW+0D2IQxLmW6IhxlgctTFM/o1YkCMTBNDCZIpasUKv6Ed/xEyf7wbsgO+McReEpQnmU9HL
IaUcQYG53tSswI9S0icIAahYiAIEYEcekMBnDazGVKlFFNThETUrshK1FqhZNI10Y+klCBzZBKIMWzt01ai4C3SWVM2Ky5XpNXPEAl0YIDZWxcKowOctYUjm
2O59KijiPZzKjSR0wPStyxV3/wDQMf8Ax2//2gAMAwEAAgADAAAAEHPPKLEDAMIDJFHHPLONPGPIOPOMLBAAEPHMPHPPPPPPPPPPPPPHAAHOAKIDHCFMCDOM
CLKNGMGNHKGGCDDPPPPPPPPPPPPPPPLCAACAPOOLOCILOBDHLDBKDKJEPEFDPPPPPPPPPPPPPPPPPPAEEECNGEKFNICPLIPHKCJEHHHDHPPPPPPPPPPPPPPP
PPPPCDHAAKHIOFINOIHIINLCBLJLNNPPPPPPPPPPPPPPPPPPPPPGNDCBLGBNCHGOIJLNOJLKPEDPPPPPPPPPPPPPPPPPPPPPPONHPHFIPPMCHGPPPENPOBOG
PPPPPPPPPPPPPPPPPPPPPPPPDPPPLHODIBJCCIDAOLEKMGPPPPPPPPPPPPPPPPPPPPPPPPPPPPCJLLIADCAGFCJJLNCFHPPPPPPPPPPPPPPPPPPPPPPPPPPP
KCLNHLHLHPPPHDIEODOENPPPNPPPPPPPPPPPPPPPPPPPMPPDPEMPOODCBMMPPPDPKCENPPPPPPPPPPPPPPPPPPPPPAAFPPLHCALIEEJKCAMPPPKDBGPPPPPP
PPPPPPPPPPPPPPIABPPPNLAAAFAAAJAAAANPLKABFPPPPPPPPPPPPPPPPPPOANPPPPPKIABHBKAABKAAAAPKAAAEPLPPPPPPPPPPPPPPPAAPPPPOBCAAAIAA
AAFAAAAAEPLAAANPLFPPPPPPPPPPPPKAHPPPOABGCADDAAALNCAAAAAFPKAAMPPEPPPPPPPPIPPPLCMPOAABKBJMPAAAEMPPKAAAAAFPCAANPAPPPPPPPPAP
POIAAHIAAEJCHLDDDHEGFPLAAAAAAPPCAFPKMPPPPPPPAPPAAAFKAAAPJMGEPEALFKNPKAAAAAAEPPDENKFNPPPPPPAPPPKDEAAHAJMOFHAAICBHPPLAAAAA
AAFPPKNLBNPPPPPPPPPPPPKABOFHBLKHJNEIDOPPPLAAAAAAFPOIAPPPPPPPPPPPPPPPIAFIPPHPJGHDOENOGNPPKABAAAAFLAAFPPPPPPPPPOINPOAAKAEI
PBOPMNFPLFFNNPPCAAAAAFPOAFPPPPPFPPPKAAPKAAAFAPHPGIJFAMMDBMDNPLAAAAAAPPLEPPPPPPPPPIAAEIAFAAAPEKKMJPLAAMBNJKNPKAAAAAPPOAPP
PPPPPPPAAAAABKAAFPDGPPGNNPLCANCHMPPCAAAAFPIAPPPPPPPPPLKAAAFKBAHPOJMEIEOPPPDPKLADNLAAAAFPKAPPPPKPPPPPAAAAFIJAPPPKLIAFMOMI
KOHDIHDPAAAAEPKAFPPPPPPPPNAAAAAAACPPPMCGILFHFMLODKGCHPKAAAAPKAFPPPENPPPFAAAAAAHLPPHIKFNCDCILDOLDGNHFKAAAAPKAFPPPHPPPPAAA
AAAAENPPPKJBCEPIHGDIMMEKCFKAAAAPKCEPPPPPPPPCAAAAABAFPPKELMOLPBGCKCLJCJPFKAAAAPLKAPPPPHPPPLAAAAAFPFPKKPPEKDIBFIBLJMCIPAOA
AAAPPKBPPPPPNPOAAAAAAFOAOGELDGPFJHHFDHHNHHJPOKAAAFNLPPPPKPPPOAAAAAAECONKFCJAGIOCIALGGMEFEGOOAAAOFPPPPPPPPPPAAADAEAMJNKBA
NGMLCDGNHJNHFDPOOKAAAPGPPPPPPPPPPKAAFACCBIBNLLGAJNHEGIDMILFFPOMIAAAPPPPPPPPPNPPPDCHCAIGHLDPMDGFEBCDCEPKOKPPKAAAAAPPPPPPP
PPPPPPOKPKAAIHMPPHOMAHILNCFBFFNPOAAAAAAPMNPPPPPPPPPPLPPLEAMAANPLMKIEONEIHIBJHPABAAAAAFPPPPPPPPPPPPPPPOAAAAAANPKLJAFEIGLL
GHPKAAAAAAAAAFPPPPPPPPPPPPPFCAAAAAEPLGPPHDGLJNNPOAAAAAAAAAAFPPPPPPPPPPPPPPPAAAAAAEPPGLIDGODNPPIAAAAABAAAAFPPPPPPPPPPPPPO
NKAAAAAKEPHDOPLKDPPIAAAAAAHPHLPOPPPPPPPOPPPCMKPLAAAAEAAFPPPPPPPPIAAAAAABPPPPPPPPPPPPPLPPPPAFPPLAAAAAAFPPPPPPOMIEAAAAAPPF
PPPPPPPPPPPPPPPPPLHPPCAAAAAFPPPOMAAAAAAAAAHPPPPPPPPPPPPPPPPPPPPPPPNPCAAAAAEOMMEAAAAAAAAFPPPPPPPPPPPPPPPPPPPPPPPPPPPCAAAA
AKAAAAAAAAAABHPPKNPPPPPPPPPPPPPPPPPPPPPPPPCAAAAIAAAAAAAAAHPPNPPPPPPPPPPPPPPPPPPPPPPPPPPPLDCAAAAAAAAAADHPPPPPPPPPPPPPPPPP
PPPPPPPPPPPPOENPPHCAAAAAADHPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPAAAMPPKAAAFPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPKAAAPPIAAFPPPPPP
PMNPPPPPPPPPPPPPPPPPPPPPPPPPPPLCAANLCAABPPPPPPPKFPPPPPPPPPPPPPPPPPPPPPPPPPPPPPLAAHLAAEPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
HPPPPPDPPAAAFPPPPPPPPPPPPPPPPPPPPPPPPPPPPPLHPPPPPPPPPPPPDDHPPPPPPPPPPPPPPFPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPH
PPPPPPPP/8QAFBEBAAAAAAAAAAAAAAAAAAAAsP/aAAgBAwEBPxApr//EABQRAQAAAAAAAAAAAAAAAAAAALD/2gAIAQIBAT8QKa//xAArEAEAAgEDAwMEAgMB
AQAAAAABABEhEDFBIDBRQGFxUIGRobHB0eHwYPH/2gAIAQEAAT8Q7JhiXcSGpozmKotsGpWwXBRioAjN8oCGLKiZgLLSpWjCZD5iB34gtvmA8xtxU5PGpvKm
0JMxAxxxCzLeI1gmK4krEqVKlPiOhAzMIZYMTCO31Zo6kdRx0OptBTmMrcYRuGO55hjAEAXiCuI1gpjvCKgxFFy/03gUDiAbdTCLEWUEyjtA5jtoGpvElSob
aZliVZMRvKGhFDmGJwetGPYNWEYYl+dWGiHW8b7y5dRSNFuOhvBEaKgvvGDpzoqY7Q3EgXBUxby05htFlzlC1sIul4ZehRbgRYTdKiK31piXHforQ6OdLlxe
khczC7jcvU6lzNy8Sl2JfmUNTfQVRvDxjbaBSUGY9AVVS0yxg6CS4aXRGX2+mPTUCEJlFwFQ0ysx0q44hCN4rcNo74KIEYGYqxbYa0vMrWN9CPOYUYZdOZdR
zC0WIQhM3AlaIIlfod6EdaXaVW8NtAvQxUCVqY2mYUN5Zo30GtBoV2iWwPOmxRGDoSmLcDQWWN4qLoLlQwYisRIEqVLxGLv6KaMJUVRbZxDS43jFQ0dCLica
WipzCTpqlxirgqAQlxtqDBmZY4ioiKzvMrECVDaKXK6DmCGjSNvo50ETxNtUDmXELWLoMI4gYiYlQlQaVovMoxsxCZggYI1TaXrNnmJ38JUhVx0VUd4kIaVb
XmKmYYaGLcI7R3+l1NoPmPSRvHbiGgMZRFe0uG2jvKlRNBBPmG8I9CqXgeGWbW2AZ1NPZLkHMMIt6v6UQe2QNBKgSoS4wlRjDQMwd0NbdColw9ziPE4gCOhG
xo76GlRxH6YOgSokrWtCXLzOIkDS5WYtQZcpGGtqq4sXQhorgLuWqlahokdKgSptF9OGCVLi6OtQ0pKoh2HS6i6G2kNukdb6B1Iy9ibwGpaON46kGIY/UBly
yXHTOBxpeo3NDU3gKjCZcqgYlRNbl9NS9LgwadJ3mAhJVMTTdpsj9OZfTehLRbdAxqynxBEKMstLlwySsxOk3gNoQgIlSoaBHETa55aXN0MIvqFQ6CGj0tQQ
/wCDA1CZ3oFkVLSJTUDmmVEqtagSoMVFVtg1FvUiVvElxdGbvrG9XaGo8KIKuGKreV5iHiYpcQytV7xGphrGYqoP8xWItmCQ0LZYY25y7QtcmWhpf5RASN2I
2Ha39plb53E2cHKLDDd/mWEFOlbzArEuPQbR2i5+rkImjN0wI0S1c6A7BmzGADeZeev8zCEyEz7QCtmBu/EDnCBnzEiiaRiKmBd3/Zj5gpV4WU1ciYeZSFdt
F8wbCcT2j26wvu5gC4lHD5iUNcwwpFbvNoMW9a0H10YaXpuuGhxguBccoMUNrbvBa3YECA2F2iUBX2ltVbW8conDO0FVZqL8subi8NO8EXSl4xLap2l3uyh0
cESVpWpLjL0r6soRImppb5inmXLly5cvS+q5cFCSk3mezMN4pXRcvPRX1UaZlo63L7VSmV2RHMsy5ejv0HbfpFRx0USkRFvWpUrpCcab61Kj2r7Ndd/R60qV
DW9a6alaBOIvQQI7dNR7d/UK7p01AVFlZjK0N9GV1VKldZK6a+oPXcJnSpWYY3l40Oq4Z2lpXU9u9a7GK+i32DoMcS5eYj31rHWqZR5qO/cNCXpXQ/R66Xs7
wGV5i+GX05rsES/LsVrWp0uj9GNWG3bDmKm0W+m9KC2asOmy4jbcp8xK7Tod6vXHS9oMRoGbl9Lo9J00+8VhN1Hdi9u06H0wjDR7ZK2t8TxNvQr5mGYDMr4l
lNw4j3b7D0kfSPWdL08aOhoNG+8W/QcRkDgeYGQ7wHWXxtKG1jvnW9J6Qj23q4nHSZYtyse/f3HEtKEeKxAG8bbcxXjuvRfXXQaPoiPUdD1kYdBhxEKncIAv
We7N21db12atrr4llryGYKfDvvePRmj2npOtztAjcEq8wYtilePPdoeyAWAW8XvLcUDzFxt0V6Z1PRmj3Hshi3aAdthvLh2hGd3hiso2xk2lY2wx1uPWS8Xg
eYlDwm0WW95d9L3zqroNH09Sup0OtECHzgtgv2Ed3Fb/ABAsFYoH8/MsB4qgg1tK7FYMq5dWQtrMAACOQe3M8hDl8xW2+mOp1NHaPoHpPQVJwyg3y/UV0bsf
i8s5HPMDgvwTOT8RRqsm+tSumn4QKgAByXXn4jqUS5O9S8iqd68w5xt6N6Dtp6Q7DodbpPaiXDLmK25Sl73cBQyvzLyC3z/3EWgOVX7EGL+3RxpUqBF+S4Vh
Vq3iAYp6MV9Vd3jmeSCmrv36n0V9p9Idh6mGl4qAAUvdll/LpgXfxGh2UgaWbFfbaUkDRexv7zgG28497zoFwLNpWalXEastw0jGOII1IX7MSm/lzwn9xuI2
bjH224iGq4jv0vfrovQ0enmPfem5cvpYdLDQWgbzOIstbS5eIck2xFRzsH9zBTwPYJkvlKr2lWvgnE2s+1N/1Fa8XUQq822QU5aAIgWAlB8/7gF3DP2v/cAb
dlaZS2m9x2D6U0dTV772WXpXZ4fF9Humwc1LIeEpQlmxP3HavlaIGX2IbpSTdqyG1arJbGcV+o1+0kr5ZcxTVHZPEpwUAPuOYQ0FAvbmWMmhRximJt8GPtB+
l9h9Q6GhHvPS9x0NCOX9dBvMhcVXtcYA/fz4AqDx73ECBi/6lK7gr4SA5svteBiVCtzDi7u4ZrBa/lCJpeGt8n8QUxUSPWWUN/wxc3FYe2IFAb9h6b7T3L+g
OhodNCHMulFVplVatt+CHN+b0HJhpQ7ZMSoaL5Hjnb4m5gm4t6Syck2Kc2MvyR2GGeK4H+JcgHA94A6XQPvFGcaJQm4yqqbP67D3mVqfQzoeg1dVQfGhLb4L
QEUqa3fN1LReKPeVvKx8nH8xjKxwh33/ALhqbWQfDv8AyxrbBur8I4/UuIuy4qYEsG/iVJ9kM7TNgzs6IoNOYVSc8R7D6Z9Px23Q0NWGhtpW29iWBYH8hj91
CbCbR+H+YEAUNX/n/uIUxVt3NQSwEwxw/wDwm8uVcxwb5z955m1R3+SZLOJuHF3HIT70pMXwckd4yu3jsut+te0w6Ll9HEJxDZXedWFhuqoCew2+RIro4A9m
P8fmOtDxu6EuJ5B/hn+ot3DF0ucQyxKUjCxuPENK630JOfUcasrssOmpUNK0C9pchA1NzLH2BCXYLcbFTw2WZ0q1OWkM3+IEBA4Da1CriVqePEfBtL0rVbb0
E3WazKWvESWMb5V7Qz8NHqda7T0cx372/qa6TougrfH7lnUeBd1ue2FAZJMc0q+wCMxgWTa8f9+IU8FVG+BTf2qOa0NalStFTf2lR4HAxXxtJKylmyeTmXwb
3rytowNhvKfTXoaPbOwd1h3Ep1uv7CIa8JeDYK/I/EplFo+yw/k/KCdVNPkf4/mUUKw3fZiFY0CPUwnGL+cSlHcxGqWbL25J7+JjNthPLxHC/uiU56Xu10mj
6M7B0vQdJtqSw90/kv8AqIrOClN71DaRtZxR3+4/mDXyFeacj7Rjerynj2jvrUrpqVCxE34iKcuYNNwg5XB4fEJSXipjMs08m82jJuf3HqvW+w9J6U9MR0rM
OxlQD4gxCYD4q/vSwBtyEyClfn+JTdJ26j77b5EuctfAUvuU9VdO0YIXeYlZg4q65+8M1mmDQGG3t/tC6rDFMFkfQPSavrmHUakYTI+zn4lrbZeFxf4iSNts
oUr+YojloGVdfnL+5SiQVoRA+Br7oeu0UOVB8g/ap8uuunmNYMUz8kDPvGDvvwnQ0tHJ5+faHhHEadNdt6K6H0V9t0O5WxYq685gGEcKb/6LgZIso5MX5fqX
WJO8IJfht/CNV46ChfJb9ECq21UBL7NJ+WAlrdm4s19rr7TnRMD57VC18R3s3l2Sq62SoALaPguLqFxANnB/qBPcbvXknIte+/S97nofRVpfZe8NOwle/EBJ
QPCqGvZsYtcbRrGA8gZmyynkBYYNnjJTAj3o3F3a/Zt2/IsxT63iYma9ufvHT9q+jnqI5r8SmG544jssw7SyuBcLY8/LxAuhcFbFwH9fMpsoPuIKoK4HMvIn
edbhq9l7PGldlhvrWp01DeL7mws+WN2xJy2xf7hG7HmNuznFTZ95Me0eRX6Cdvmn9QQjuMBKDy1+COLj4mnKFb2P+hESP4jH5iFpHsUaTeszJEO5ZWt1U/j7
0xmjlZurx/Z/8ljLrC2yf9v8Q1ogQwsAHKS685i3IcA434ZehUMqNdbWzKMR31e09Bq9l7R2mGrqdRvEWYzSrzYH8xFXV+1mAe9koG8bE4vaJ92BYFEDcd6g
Vf8AJJf5qSsK8V94lqNxAE+aavtSAGbwDCuB7Nj94mYR6w4eTklbYyBwSz8nRzoGYX+BO8vquhGGX9gpWE/+DFushYFaKccMv/FqLvk96/Lcvewq1kyY+FeE
gXsVSktx4T+ZX4CQb28j4x8xIaq87PBo2OL2mNGlZRlaB4X/AFFVCkgziPoDV9GdphpUFdk3hqJh7ZVVfaogCE1N6Tms/qKfN1Mu5Ubb5XXimCADAq1N7xdP
3lB6Gn2Gw/qGEwGpWCj+6+xADTUWvEL+LG/aH5C25AXV/p/EKGbcOU5gNQbUZNr8DzBMf40NivhEihqm5k41pawMsRhkXtv/AN7xsKBRQnYa8/3DRVc1n2G5
i8/ENsFDqrqjXmh+SPgBaJyb35P9S7CWEADhr83Hqp74Fsvhp9oLDI3waLDFUXjeFYwfZNwJtbzUYEw24m1Dl495QThQgFb5/iBuYav7bkzNO3kXySwAqh7l
5uV2uU5hy+hOh9Kw7BDLDgzz2DABa4I1KP8AgoL/AJlzhcW5YXxiOoCEzelubgMjK2+GIDXACjf4QfzBVfOPENFWG3jeWOZY1lCVaKtftiPCxNUixX5VfCeJ
vaQFZ3Y4RQ+ISgCyN/k+cDftL2QrKsOcPbFwiSuKhZi/4gkQZuGHZfxC1uJjuweDaVCIgIG8pj3uYryUKivG4ooqIe71Xje+d/ssQxgXlG67HneXzstqrPgw
IqFCNQWOftmLgpBl+48u8rvW5Z+D5/i4F+yCct8uP+8xauKoMfn4jaJyX/rmEawv5MJFjf2hUXHQ+hes7J3iG83XZNVKRkcxwiJ3YqrYlQ26IHY/4xAKiCGr
L3Ls2jX0IE99tvvCEmU7KuUHb33q5lqfAv8AuXXVUO8o8Tx5gCFitBu+Xyywk2r+20QDRLFAFX7Z2hENM8tBsgUGYNjvjyfMNQUGrnv5ftE7zV835t3rb2j8
5ZRs3xiXTKeGnCmsbwULL5bE9pXkuQVPhP7lwI+6L9+ON4nDm6F1+IZKHHFHxLNvq8MXxcYqbrPuFeIoVm6Jl9yUgHGW4jGsRjh4rofUXOOzx3SG8W8d2HSa
YWnhvn/RLaBirBuyjwaVSe6wejJEbjfI4uKhW7eBnfnIEd4pwtuXOTaGB4IW/wBf3FqeJZ9+JheQC5Xe4q5Jc1V1/qKC2z7IGrEHeoSAHZF7Iwk4NNO6DZR1
eLfXCzaAIQfLPlPH+YdJuDcDa1552lCKBgoD/s4lIMFlL5t3hoNobV+X3jjuavCsf1DO1ph8bb+8dTbFbW8ptHZd8CvZ9orrRYAtwFwSMteNz5SGEEK8j+I1
mAKclxrFNtkz4G63hqh40d++dD11pns13DS8RgX1h0YC/aLIXcvD7QRFtzd2eaiELDCux7uIHBisU9nG0G4jkcq3hviMgszerXmneGCxUML7hms/mVXgORA0
e5NxFPAv/q2lkargzf4m/AA2IcQeYNv8TfQRzdWS8StxQpgJXbawDbffYlJHeV3Qx/Rt2lAe3t7xwDAs/EKmXG0y3bvDAoHniLi9lniXKAP1GARuXmN2UQGG
vLFNwra7v3uAtgRuqXQ2Ybn7RAABrGJbcHt/iWzo7900NtDR9fejtDrfxld6qxA7viuX/wCSsKSbNVfzLYQc8y8VXc4MGft+4gZxdGyu1Q5fwAX4qbGVHI38
nGI/blKbKnh/zGGx2pzEOwOKuMot3PmoiVbLoCOyPjA95fR2cHuN/MZprLhi64/7xEKTsyrEEGw85gnYoCizyVTLbXLYZceS62liYU4djyzDSoVsD7xZhmCy
3bLLwizCy0+0SqOp+H3juYXe+KhKxgKIxV2wRWs5j3SMOh9CehOqoLhUeyuP5l7q6YONocK8oKQ+IjQBQLZgK5Mm8RuxVfErULbPMNuTnn5iy0vxn3RIFeRT
VkQDVl4x+uIVBlZblAG3PiDtfG/5qbgGAlVhLYRqKIWVbr+MS/loaMUHmVl7Vgk3cPtQH3laO7qWTCQXz3jFviNwm3dKPaNS1TqbfKsYP152+xsQxgHLV/M5
CaRtNbEbmWV4MJovKwHyH8y/9m43LvkrTmPfJzDbR+hHUR7UaoheTb9zkAhKP9QwExNFfmEksRoGU97oM+ZyOylH7QQt9wIP8RCtooVV85iULfcfsh+Vun/7
ELMhyDZlZLPjaLhFbAxQ2o8kahYcVEICS0Xu/wByjIEu23vLA0FmjC+WeBgVK8UEQtOboDvnMFszlPyXBTQ3aNfuWmCvLAdV0hyfMvHkWi/dzCkcqgS97ghV
1CwjAyKI3YB/afMYTRvuX7xdwL1e+R3ho+uNug6iWFIuQDN4ICXgaNBGBATneWACDBMfdibbo2r+SITbKrBfKVOUaGobbhi4bALvA9jzKQqVFufDGqqqeIWj
f7zbtbvEURbxXmKjMg48So4C4CZCcVsTeV77Y9oIirYYfE8NTgpztEOgdxL+ogDIIg5jSgZWJPiJn/JT/gS/udDnX3itOOqrNQD5uqZIl9gI+8SEpYxzHehv
H1mesh3TRj0mhGOTl8pk2NCwho4ZSofQzZ4ZdyGoZtwC+wEFYZdjMBYuip8oOj3pWr39pe8hTm7hmxpl4UYKmEq4cbxRDiwzFcN1CPsRzcMl3l29WsJIQxeS
E2reKHwNp5e5aQKppsrBIGQXiZsyZcYjCpaqEIC64pyg4ntxNzrzE75q+gNDuGjOZz0GhuQO2w0EBuUpDyf/AGNCwgoyXz43gG1hwISttuYte2sEfljXRw9p
gmVFXKT4gYlBYbwW/wDEasysTLxg395WBWXK5gwiHL4hotMZ95kv2myBhqAcfmWaRWXLvGCJxvBAXO57RgPFcxVSuV8x258EV5fecarCpwmMWljxMSaV3TV9
Ad40dDU05m14mBwW7q4QiUliuKhIcgDFuD+4BBmvGIHrUpwgwaG+cQ0ozLGpsRaMby9AZ9oiZXlD2y/m8yq9YMQFYiTZBYYi4omWPzGGXaZDIeZiWBfEOjAv
mXZXW2YywNXU2rc4S03ErtEYRhHscanSd40dCVK0JzBkhPCIw3Xyb/eKJbXmqXlaUrXFUfqCGNoRjtBY94KAXMYCmNeXEowqXOMs4zHaDyx3Ty+eZuJDn7x1
WQubTxPmDGJsnMrWYsY24hizeKKqwqXGvvHXbjmWLo97iGj3DsHeI6Ey490qNak5n7UGgYGYl2zBVRc2bOLl8vLuxww+3hg2z9wuUAI/DCG8YgMpFeFBzAyq
qdkqGJxLtv5qPaMkiRPlRAic2B507kwpzCj8yjaUpdiWE0u0Q3z5i14N5hRG/GjHRtsZFudD2DR9Id0hpzEWaGV/UCU7Y8TffUnMtSpXShuR9oHKHvsv9fzE
2ChD7R0Uwwz1D3IbanwwQ5/LKeIDxUBdwA2ruUYYNmJdawiKO24PBE3HHM5ZVhIZuPywgnuaFZd7QzJjmKJYDtFvLuUCXeGuOjLgqDMyUqPc5049Edxh0JQb
RCvutugjMElKHJ4jBWZJLmeBfvFVAut5sIJiDiWS48ZlShu8e8yDz/iGSG3dUZuWspbdtpZCxxazjtyuG5G13oLiFx8yuxUNGwnmBiAT4LFyOJw8XFax2j6A
0dOPRHYOxY5l2LwaXrcYMqpohb2hA5AjOyoeWIGWzuS8BxPE6diTyLh15M9hFZ8Q45hV+JS0CmjPljIBK3K/j9TFsH4I6jhKTHNuY0iLXzHMVVMIu2a4h4Vz
NwVCac8S3cMXMXpNLi9q9K+h3RGOgUBMhTLk1N4VBapx8xqtdh9ybwbnMEbFneIhLRIhVGpiWGJSagUfeEUqhzcFFJmIdpQT4zHXu+V+LxKnYt2LtUBne38w
As/qot7SqVMsVrEssoW9vjFN+CIhaTEvXmMew9u5fpTsul9bFtDvFgroqEj7zVHzACgCoTLGh8T2tVTMHEHh0DErniq/E/mLAiOIhME8MGg4qG4KSkYKDXNX
/ELWYoaU/P8A1xJ6ZTe+WAWuVvyEKEoLMw3K1GLifKLg+Myp2Wxau+0VUIyrjHvvW+prprV0rQalst6BDfbxrZQ2748RAFFvEEC22ZiVoO0viXgtnMGtMiwe
cc/EVVbkqv4feOSNe5T/ADHQa4V/SAuK0Va3eZdcn3uW21NhsPMEKTMdLse8ykWPaU1KjOKznmMLH3ibn7gAsuJbLdjH6Hnq40d9DS5cOkNK7JLlkUzZH5ho
8crjkyZULZutiB5hmJW0LERMnDDMC+QcpODTCjSf5jRiERt/z7yx61tmbmklmP8AFNuLZbQVzcuy45gyGvBBpLgWBXEdBSVCtREG7ZcjHpfo2+h0HTs0No79
jGjGkuVbzfhjjse9wUD45lzv7QybbmEbg1AssuGrVS2YSqqp7nxN2EArETYFgpHgJQKVe3G8BJpcmYcyFxvtKVQ5qIw2djHKq0/DFGcco44jRcel9BXpyMJf
Y2Ql0aXGHYc28jcNpiKS5RsEqJErMVoPjMa3Hgqn2gJjdFNg3Y5GNdLlhXosymdfDFj5OEwg4qIoIqPBoXB/cLCZ3V2Y20J8YaiS4oG8OR7/AN4BZywrFxyG
ViPm4rdHpe+aPpjR7Iy/eL2r0HM2WFw2sMIh+ZYEXtBgD5whUKvcfxHCVKprUqKY2K2mAB5W3FdzeavaJu2ediIG5y2mNjlGMEza3ipVz4goB8xICTfjQRko
jvRceh9BxL9RcYdB3DpubTMEsGx5jgYYbFv7iUqK5j8SNFQ/EVJNu7ZGoK8VFop4XCqguVcowfO0xtigTW17xBjY7PEAhQqIqDUl+8dmO8em+i+1f0God06T
RzSZLjtUAUqe8x2wyl23IHElTy8ssAK9tIR8j7Llj5oWwLmWJS/eGAGwtWEvKV5ZZtV7IwrZWgbWKsWPQ63L9C+kxHq47x0moRFDmXnLIYWfFwVEcRrQ20DF
wcCjt5iQD7h/ELUTwlH7wGlvmLVrhW9xgsqVmGPbaBAKiIolEdXfiIy0fVPqXQlw7p0EvUkquFdk/E9sjKRCjBMCIN2U/jxW8QiUibBQPEwpr4mH5eaiDcHO
N45xR5qHJZcR8BjHW+mfWO/fOm9XO9X8SkvHcpYYYJvT5qDwCe8DVAweVRqyIGgPvFCqiBFBAEm3eK1dHpfqNx0PR3pcYGVvnaKh4edp8nEThzXCQaNAR/zY
swkpSwzFNbS8x8X8XEcXb136Z9MdD6m9DEyRFuM94gLiRzjaUdH5ZRWg8MBoKc3EbgPvtL42feXNY8aPrH6Adyuq9Ll6XhI+0zan5mxu8Dibsnux7cCK2/xN
0LGX1X3XU0uXpcuX650N+5fQdd6Xpel+oI63qeqrTbR7t/Ur9BfZdKjv6Q9C9+/WV2Dod/SHfYR716n0I7R3ju3133j6GS5cuXHpPS3Ll+kvpv6ady+t9M/U
HoO6dTCV/wCDeg7ppcuXL1v0L9Xv6XUr6S9k+k39euPpH68eteqo/VK6Df159duXpfpr6r+snav0T/4QnWf+QOp6jtX/AOGPRuj/AOHOw9t79fWjsOtSuuu+
aVoR+uvce8f+Dey+hPrtw7zt0X/4oly//IncNuo63/yp1v1ypt6gl63o+tOion/lzR/849//2Q==
]=]
local KNI_BACKGROUND_IMAGE = ""
pcall(function()
    local assetFn = getcustomasset or getsynasset
    if type(assetFn) ~= "function" or type(writefile) ~= "function" then
        return
    end
    local path = "KNI_MuscleLegends_bg.jpg"
    if type(isfile) ~= "function" or not isfile(path) then
        local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        local output = {}
        local clean = KNI_BACKGROUND_BASE64:gsub("%s+", "")
        for i = 1, #clean, 4 do
            local a = (alphabet:find(clean:sub(i, i), 1, true) or 1) - 1
            local b = (alphabet:find(clean:sub(i + 1, i + 1), 1, true) or 1) - 1
            local cChar, dChar = clean:sub(i + 2, i + 2), clean:sub(i + 3, i + 3)
            local c = (alphabet:find(cChar, 1, true) or 1) - 1
            local d = (alphabet:find(dChar, 1, true) or 1) - 1
            local n = a * 262144 + b * 4096 + c * 64 + d
            output[#output + 1] = string.char(math.floor(n / 65536) % 256)
            if cChar ~= "=" then output[#output + 1] = string.char(math.floor(n / 256) % 256) end
            if dChar ~= "=" then output[#output + 1] = string.char(n % 256) end
        end
        writefile(path, table.concat(output))
    end
    KNI_BACKGROUND_IMAGE = assetFn(path)
end)

-- ═══════════════════════════════════════════════════════════════
-- KNI_UI v2.0 (embebido y corregido)
-- ═══════════════════════════════════════════════════════════════
local KNI = (function()
    local KNI = {}
    KNI.__index = KNI

    local COLORS = {
        Background = Color3.fromRGB(12, 13, 20),
        Panel      = Color3.fromRGB(20, 22, 33),
        Panel2     = Color3.fromRGB(29, 31, 46),
        Accent     = Color3.fromRGB(145, 77, 255),
        Accent2    = Color3.fromRGB(83, 49, 163),
        Text       = Color3.fromRGB(244, 242, 255),
        Muted      = Color3.fromRGB(160, 158, 181),
        Border     = Color3.fromRGB(55, 48, 78),
        Good       = Color3.fromRGB(80, 220, 160),
        Bad        = Color3.fromRGB(220, 80, 100),
        Warn       = Color3.fromRGB(240, 180, 80),
    }

    local Services = {
        Players          = game:GetService("Players"),
        UserInputService = game:GetService("UserInputService"),
        TweenService     = game:GetService("TweenService"),
        RunService       = game:GetService("RunService"),
    }

    local function make(className, props, parent)
        local obj = Instance.new(className)
        for k, v in pairs(props or {}) do obj[k] = v end
        obj.Parent = parent
        return obj
    end

    local function corner(parent, radius)
        make("UICorner", { CornerRadius = UDim.new(0, radius or 10) }, parent)
    end

    local function stroke(parent, color, thickness, transparency)
        make("UIStroke", {
            Color = color or COLORS.Border,
            Thickness = thickness or 1,
            Transparency = transparency or 0.15,
        }, parent)
    end

    local function padding(parent, left, right, top, bottom)
        make("UIPadding", {
            PaddingLeft   = UDim.new(0, left or 10),
            PaddingRight  = UDim.new(0, right or 10),
            PaddingTop    = UDim.new(0, top or 8),
            PaddingBottom = UDim.new(0, bottom or 8),
        }, parent)
    end

    local function tween(obj, time, props, style, dir)
        local t = Services.TweenService:Create(
            obj,
            TweenInfo.new(time or 0.15, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
            props
        )
        t:Play()
        return t
    end

    -- ═══ NOTIFICACIONES ═══
    local Notify = {}
    local notifyContainer = nil

    local function ensureNotifyContainer()
        if notifyContainer and notifyContainer.Parent then return notifyContainer end
        local player = Services.Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")
        local screen = make("ScreenGui", {
            Name = "KNI_Notify",
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            DisplayOrder = 1000,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        }, pg)
        local holder = make("Frame", {
            Name = "Holder",
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -16, 0, 16),
            Size = UDim2.fromOffset(280, 500),
            BackgroundTransparency = 1,
        }, screen)
        make("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            VerticalAlignment = Enum.VerticalAlignment.Top,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
        }, holder)
        notifyContainer = holder
        return holder
    end

    function Notify:Show(title, text, duration, kind)
        local holder = ensureNotifyContainer()
        duration = duration or 4
        kind = kind or "info"
        local color = COLORS.Accent
        if kind == "success" then color = COLORS.Good
        elseif kind == "warning" then color = COLORS.Warn
        elseif kind == "error" then color = COLORS.Bad end

        local card = make("Frame", {
            Size = UDim2.new(1, 0, 0, 52),
            BackgroundColor3 = COLORS.Panel,
            BorderSizePixel = 0,
            ClipsDescendants = true,
        }, holder)
        corner(card, 8)
        stroke(card, color, 1.2, 0.2)

        make("Frame", {
            Size = UDim2.fromOffset(3, 36),
            Position = UDim2.new(0, 6, 0.5, -18),
            BackgroundColor3 = color,
            BorderSizePixel = 0,
        }, card)

        make("TextLabel", {
            Size = UDim2.new(1, -20, 0, 16),
            Position = UDim2.fromOffset(14, 6),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = color,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, card)

        make("TextLabel", {
            Size = UDim2.new(1, -20, 0, 24),
            Position = UDim2.fromOffset(14, 22),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = COLORS.Muted,
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
        }, card)

        card.Position = UDim2.new(1, 300, 0, 0)
        tween(card, 0.25, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Back)

        task.delay(duration, function()
            if card and card.Parent then
                tween(card, 0.2, { Position = UDim2.new(1, 300, 0, 0) })
                task.wait(0.25)
                card:Destroy()
            end
        end)
    end

    KNI.Notify = Notify

    -- ═══ OVERLAY GLOBAL DE DROPDOWNS ═══
    local dropdownOverlay = nil
    local function ensureDropdownOverlay()
        if dropdownOverlay and dropdownOverlay.Parent then return dropdownOverlay end
        local pg = Services.Players.LocalPlayer:WaitForChild("PlayerGui")
        local existing = pg:FindFirstChild("KNI_DropdownOverlay")
        if existing then
            dropdownOverlay = existing
            return existing
        end
        local screen = make("ScreenGui", {
            Name = "KNI_DropdownOverlay",
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            DisplayOrder = 999,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        }, pg)
        dropdownOverlay = screen
        return screen
    end

    KNI.EnsureDropdownOverlay = ensureDropdownOverlay

    -- ═══ KNI.new ═══
    function KNI.new(options)
        options = options or {}
        local player = Services.Players.LocalPlayer
        assert(player, "KNI_UI debe iniciarse desde un LocalScript")
        local guiParent = player:WaitForChild("PlayerGui")

        local self = setmetatable({}, KNI)
        self._connections = {}
        self._tabs = {}
        self._destroyed = false
        self._minimized = false

        local gui = make("ScreenGui", {
            Name = options.Name or "KNI_Interface",
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            DisplayOrder = 50,
        }, guiParent)
        self.Gui = gui

        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
        local windowWidth = math.max(300, math.min(options.Width or 620, viewport.X - 20))
        local windowHeight = math.max(280, math.min(options.Height or 420, viewport.Y - 20))

        local root = make("Frame", {
            Name = "Window",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(windowWidth, windowHeight),
            BackgroundColor3 = COLORS.Background,
            BackgroundTransparency = 0.08,
            BorderSizePixel = 0,
        }, gui)
        root.ClipsDescendants = true
        corner(root, 14)
        stroke(root, COLORS.Border, 1.2)
        self.Root = root

        -- Sube la foto a Roblox como imagen/Decal y usa su ID en BackgroundImage.
        local image = make("ImageLabel", {
            Name = "KNI_BackgroundImage",
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Image = options.BackgroundImage or "",
            ImageTransparency = 0.28,
            ScaleType = Enum.ScaleType.Crop,
            BorderSizePixel = 0,
            ZIndex = 0,
        }, root)
        corner(image, 14)
        make("Frame", {
            Name = "BackgroundShade",
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(4, 4, 9),
            BackgroundTransparency = 0.28,
            BorderSizePixel = 0,
            ZIndex = 0,
        }, root)

        local top = make("Frame", {
            Name = "TopBar",
            Size = UDim2.new(1, 0, 0, 42),
            BackgroundColor3 = COLORS.Panel,
            BorderSizePixel = 0,
        }, root)
        self.TopBar = top
        corner(top, 14)
        make("Frame", {
            Position = UDim2.new(0, 0, 1, -12),
            Size = UDim2.new(1, 0, 0, 12),
            BackgroundColor3 = COLORS.Panel,
            BorderSizePixel = 0,
        }, top)

        make("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(14, 0),
            Size = UDim2.new(1, -150, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = options.Title or "HonenxWhite | Reborn",
            TextColor3 = COLORS.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, top)

        local function topButton(text, x, color, callback)
            local b = make("TextButton", {
                Size = UDim2.fromOffset(28, 26),
                Position = UDim2.new(1, x, 0, 8),
                BackgroundColor3 = color,
                BorderSizePixel = 0,
                Text = text,
                TextColor3 = COLORS.Text,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = true,
            }, top)
            corner(b, 8)
            table.insert(self._connections, b.Activated:Connect(callback))
            return b
        end

        local restore = make("TextButton", {
            Name = "RestoreButton",
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -18, 1, -18),
            Size = UDim2.fromOffset(52, 52),
            BackgroundColor3 = COLORS.Accent,
            BorderSizePixel = 0,
            Text = "HW",
            TextColor3 = COLORS.Text,
            TextSize = 15,
            Font = Enum.Font.GothamBlack,
            Visible = false,
            ZIndex = 100,
        }, gui)
        corner(restore, 18)
        stroke(restore, COLORS.Text, 1, 0.3)
        self.RestoreButton = restore

        local content = make("Frame", {
            Name = "Content",
            Position = UDim2.fromOffset(0, 42),
            Size = UDim2.new(1, 0, 1, -42),
            BackgroundTransparency = 1,
        }, root)
        self.Content = content

        local rail = make("ScrollingFrame", {
            Name = "TabRail",
            Position = UDim2.fromOffset(10, 10),
            Size = UDim2.new(0, 132, 1, -20),
            BackgroundColor3 = COLORS.Panel,
            BackgroundTransparency = 0.12,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = COLORS.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
        }, content)
        corner(rail, 10)
        padding(rail, 7, 7, 8, 8)
        make("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, rail)
        self.TabRail = rail

        local pages = make("Frame", {
            Name = "Pages",
            Position = UDim2.new(0, 152, 0, 10),
            Size = UDim2.new(1, -162, 1, -20),
            BackgroundColor3 = COLORS.Panel,
            BackgroundTransparency = 0.12,
            BorderSizePixel = 0,
        }, content)
        corner(pages, 10)
        self.Pages = pages

        local dragging, dragStart, startPos
        table.insert(self._connections, top.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = root.Position
            end
        end))
        table.insert(self._connections, Services.UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end))
        table.insert(self._connections, Services.UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end))

        topButton("—", -72, COLORS.Panel2, function()
            self._minimized = true
            root.Visible = false
            restore.Visible = true
        end)
        topButton("×", -38, Color3.fromRGB(130, 43, 65), function()
            self:Destroy()
        end)
        table.insert(self._connections, restore.Activated:Connect(function()
            if not self._destroyed then
                self._minimized = false
                root.Visible = true
                restore.Visible = false
            end
        end))

        function self:SetTitle(text)
            local label = top:FindFirstChild("Title")
            if label then label.Text = tostring(text) end
        end

        return self
    end

    -- ═══ KNI:AddTab ═══
    function KNI:AddTab(name)
        assert(not self._destroyed, "La interfaz fue cerrada")
        local tab = { Name = name, _ui = self, _controls = {} }
        local button = make("TextButton", {
            Name = "Tab_" .. tostring(name),
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = COLORS.Panel2,
            BorderSizePixel = 0,
            Text = tostring(name),
            TextColor3 = COLORS.Muted,
            TextSize = 11,
            Font = Enum.Font.GothamSemibold,
            TextWrapped = true,
        }, self.TabRail)
        corner(button, 8)

        local page = make("ScrollingFrame", {
            Name = "Page_" .. tostring(name),
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = false,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = COLORS.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
        }, self.Pages)
        padding(page, 10, 10, 10, 10)
        make("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder }, page)

        local function activate()
            for _, item in ipairs(self._tabs) do
                item.Page.Visible = false
                item.Button.BackgroundColor3 = COLORS.Panel2
                item.Button.TextColor3 = COLORS.Muted
            end
            page.Visible = true
            button.BackgroundColor3 = COLORS.Accent2
            button.TextColor3 = COLORS.Text
        end
        table.insert(self._connections, button.Activated:Connect(activate))
        tab.Button, tab.Page = button, page
        table.insert(self._tabs, tab)
        if #self._tabs == 1 then activate() end

        local function row(height)
            local frame = make("Frame", {
                Size = UDim2.new(1, 0, 0, height or 34),
                BackgroundColor3 = COLORS.Panel2,
                BorderSizePixel = 0,
            }, page)
            corner(frame, 8)
            return frame
        end

        function tab:AddLabel(text)
            local r = row(28)
            r.BackgroundTransparency = 1
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = tostring(text),
                TextColor3 = COLORS.Muted,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
            }, r)
            local control = { Instance = label }
            function control:SetText(value) label.Text = tostring(value) end
            function control:Set(value) label.Text = tostring(value) end
            setmetatable(control, {
                __index = function(_, key) if key == "Text" then return label.Text end end,
                __newindex = function(t, key, value)
                    if key == "Text" then label.Text = tostring(value) else rawset(t, key, value) end
                end,
            })
            return control
        end

        function tab:AddSection(text)
            local r = row(26)
            r.BackgroundTransparency = 1
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -60, 1, 0),
                Text = tostring(text),
                TextColor3 = COLORS.Accent,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, r)
            make("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(40, 1),
                BackgroundColor3 = COLORS.Accent,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
            }, r)
            return { Instance = label }
        end

        function tab:AddButton(text, callback)
            local r = row(32)
            local b = make("TextButton", {
                Position = UDim2.fromOffset(4, 3),
                Size = UDim2.new(1, -8, 1, -6),
                BackgroundColor3 = COLORS.Accent2,
                BorderSizePixel = 0,
                Text = tostring(text),
                TextColor3 = COLORS.Text,
                TextSize = 11,
                Font = Enum.Font.GothamSemibold,
            }, r)
            corner(b, 7)
            table.insert(self._ui._connections, b.Activated:Connect(function()
                if callback then task.spawn(callback) end
            end))
            return b
        end

        function tab:AddSwitch(text, callback, default)
            local r = row(36)
            make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.new(1, -72, 1, 0),
                Text = tostring(text),
                TextColor3 = COLORS.Text,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
            }, r)
            local b = make("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -7, 0.5, 0),
                Size = UDim2.fromOffset(48, 23),
                BackgroundColor3 = COLORS.Panel,
                BorderSizePixel = 0,
                Text = "OFF",
                TextColor3 = COLORS.Muted,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
            }, r)
            corner(b, 12)

            local control = { Value = default == true }

            local function render()
                b.Text = control.Value and "ON" or "OFF"
                b.BackgroundColor3 = control.Value and COLORS.Accent or COLORS.Panel
                b.TextColor3 = control.Value and COLORS.Text or COLORS.Muted
            end

            function control:Set(value, silent)
                control.Value = value == true
                render()
                if not silent and callback then
                    local ok, err = pcall(callback, control.Value)
                    if not ok then warn("[KNI] Switch error:", err) end
                end
            end

            function control:Get()
                return control.Value
            end

            render()
            table.insert(self._ui._connections, b.Activated:Connect(function()
                control:Set(not control.Value)
            end))
            return control
        end

        function tab:AddTextBox(text, callback, opts)
            local r = row(56)
            make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(9, 2),
                Size = UDim2.new(1, -18, 0, 18),
                Text = tostring(text),
                TextColor3 = COLORS.Muted,
                TextSize = 10,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, r)
            local box = make("TextBox", {
                Position = UDim2.fromOffset(7, 24),
                Size = UDim2.new(1, -14, 0, 26),
                BackgroundColor3 = COLORS.Background,
                BorderSizePixel = 0,
                Text = "",
                PlaceholderText = "Escribe aquí…",
                ClearTextOnFocus = not (opts and opts.clear == false),
                TextColor3 = COLORS.Text,
                PlaceholderColor3 = COLORS.Muted,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, r)
            corner(box, 6)
            padding(box, 7, 7, 0, 0)
            table.insert(self._ui._connections, box.FocusLost:Connect(function(enter)
                if callback then
                    local ok, err = pcall(callback, box.Text, enter)
                    if not ok then warn("[KNI] TextBox error:", err) end
                end
            end))
            return box
        end

        function tab:AddSlider(text, min, max, default, callback)
            min, max = min or 0, max or 100
            default = math.clamp(default or min, min, max)

            local r = row(46)
            make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 2),
                Size = UDim2.new(1, -80, 0, 18),
                Text = tostring(text),
                TextColor3 = COLORS.Text,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, r)

            local valueLabel = make("TextLabel", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -10, 0, 2),
                Size = UDim2.fromOffset(60, 18),
                BackgroundTransparency = 1,
                Text = tostring(default),
                TextColor3 = COLORS.Accent,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
            }, r)

            local track = make("Frame", {
                Position = UDim2.fromOffset(10, 26),
                Size = UDim2.new(1, -20, 0, 5),
                BackgroundColor3 = COLORS.Background,
                BorderSizePixel = 0,
            }, r)
            corner(track, 3)

            local fill = make("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = COLORS.Accent,
                BorderSizePixel = 0,
            }, track)
            corner(fill, 3)

            local currentValue = default
            local initRel = (default - min) / (max - min)
            fill.Size = UDim2.new(initRel, 0, 1, 0)

            local function updateFromX(x)
                local relX = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                currentValue = math.floor(min + (max - min) * relX + 0.5)
                valueLabel.Text = tostring(currentValue)
                tween(fill, 0.06, { Size = UDim2.new(relX, 0, 1, 0) }, Enum.EasingStyle.Linear)
            end

            local function startDrag(input)
                updateFromX(input.Position.X)
                local conn
                conn = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        conn:Disconnect()
                        if callback then
                            local ok, err = pcall(callback, currentValue)
                            if not ok then warn("[KNI] Slider error:", err) end
                        end
                    elseif input.UserInputState == Enum.UserInputState.Change then
                        updateFromX(input.Position.X)
                    end
                end)
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    startDrag(input)
                end
            end)

            return {
                Set = function(_, value)
                    value = math.clamp(value, min, max)
                    currentValue = value
                    valueLabel.Text = tostring(value)
                    local rel = (value - min) / (max - min)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    if callback then pcall(callback, value) end
                end,
                Get = function() return currentValue end,
            }
        end

        -- ═══ DROPDOWN (SIN DUPLICACIÓN) ═══
        function tab:AddDropdown(text, callback, default)
            local control = { Items = {}, Selected = default, _ui = self._ui }
            local r = row(56)
            local b = make("TextButton", {
                Position = UDim2.fromOffset(7, 5),
                Size = UDim2.new(1, -14, 0, 24),
                BackgroundColor3 = COLORS.Background,
                BorderSizePixel = 0,
                Text = "  " .. tostring(text) .. "                              ﹀",
                TextColor3 = COLORS.Text,
                TextSize = 11,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = true,
            }, r)
            corner(b, 7)
            stroke(b, COLORS.Border, 1, 0.25)

            local overlayScreen = ensureDropdownOverlay()
            local menu = make("Frame", {
                BackgroundColor3 = Color3.fromRGB(15, 15, 24),
                BorderSizePixel = 0,
                Visible = false,
                Active = true,
                ClipsDescendants = true,
                ZIndex = 20,
            }, overlayScreen)
            corner(menu, 6)
            local list = make("ScrollingFrame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 4,
                ScrollBarImageColor3 = COLORS.Accent,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                Active = true,
                ZIndex = 21,
            }, menu)
            padding(list, 4, 4, 4, 4)
            make("UIListLayout", {
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, list)
            stroke(menu, COLORS.Accent, 1, 0.25)
            local open = false

            local function repositionMenu()
                if not b.Parent then return end
                local btnAbs = b.AbsolutePosition
                local btnSize = b.AbsoluteSize
                local cam = workspace.CurrentCamera
                local viewport = cam and cam.ViewportSize or Vector2.new(800, 600)
                local margin = 8
                local gap = 4
                local desiredHeight = math.max(34, math.min(#control.Items * 26 + 10, 220))
                local belowY = btnAbs.Y + btnSize.Y + gap
                local aboveSpace = math.max(0, btnAbs.Y - margin - gap)
                local belowSpace = math.max(0, viewport.Y - belowY - margin)
                local placeAbove = belowSpace < math.min(desiredHeight, 90) and aboveSpace > belowSpace
                local available = placeAbove and aboveSpace or belowSpace
                local h = math.max(30, math.min(desiredHeight, available))
                local y = placeAbove and (btnAbs.Y - h - gap) or belowY
                local maxX = math.max(margin, viewport.X - btnSize.X - margin)
                local x = math.clamp(btnAbs.X, margin, maxX)
                menu.Position = UDim2.fromOffset(x, math.clamp(y, margin, math.max(margin, viewport.Y - h - margin)))
                menu.Size = UDim2.fromOffset(math.min(btnSize.X, viewport.X - margin * 2), h)
                list.CanvasPosition = Vector2.zero
            end

            local function refresh()
                for _, child in ipairs(list:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, item in ipairs(control.Items) do
                    local choice = make("TextButton", {
                        Size = UDim2.new(1, -2, 0, 25),
                        BackgroundColor3 = (control.Selected ~= nil and tostring(item) == tostring(control.Selected))
                            and COLORS.Accent2 or COLORS.Panel2,
                        BorderSizePixel = 0,
                        Text = "  " .. tostring(item),
                        TextColor3 = COLORS.Text,
                        TextSize = 11,
                        Font = Enum.Font.GothamMedium,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutoButtonColor = true,
                        ZIndex = 22,
                    }, list)
                    corner(choice, 5)
                    table.insert(self._ui._connections, choice.Activated:Connect(function()
                        control.Selected = tostring(item)
                        b.Text = "  " .. tostring(text) .. ": " .. control.Selected .. "   ﹀"
                        open = false
                        menu.Visible = false
                        if callback then
                            local ok, err = pcall(callback, control.Selected)
                            if not ok then warn("[KNI] Dropdown error:", err) end
                        end
                    end))
                end
            end

            function control:Add(item)
                table.insert(control.Items, tostring(item))
                refresh()
            end

            function control:Remove(item)
                for i, v in ipairs(control.Items) do
                    if v == item then
                        table.remove(control.Items, i)
                        break
                    end
                end
                refresh()
            end

            function control:SetOptions(items)
                control.Items = {}
                for _, item in ipairs(items or {}) do
                    table.insert(control.Items, tostring(item))
                end
                refresh()
            end

            function control:Set(value)
                control.Selected = tostring(value)
                b.Text = "  " .. tostring(text) .. ": " .. control.Selected .. "   ﹀"
            end

            function control:Get()
                return control.Selected
            end

            function control:Clear()
                control.Items = {}
                control.Selected = nil
                b.Text = "  " .. tostring(text) .. "                              ﹀"
                refresh()
            end

            table.insert(self._ui._connections, b.Activated:Connect(function()
                open = not open
                if open then
                    repositionMenu()
                    menu.Visible = true
                else
                    menu.Visible = false
                end
            end))
            table.insert(self._ui._connections, Services.UserInputService.InputBegan:Connect(function(input, processed)
                if not open or processed then return end
                if input.UserInputType ~= Enum.UserInputType.MouseButton1
                    and input.UserInputType ~= Enum.UserInputType.Touch then return end
                local point = input.Position
                local bp, bs = b.AbsolutePosition, b.AbsoluteSize
                local mp, ms = menu.AbsolutePosition, menu.AbsoluteSize
                local onButton = point.X >= bp.X and point.X <= bp.X + bs.X
                    and point.Y >= bp.Y and point.Y <= bp.Y + bs.Y
                local onMenu = point.X >= mp.X and point.X <= mp.X + ms.X
                    and point.Y >= mp.Y and point.Y <= mp.Y + ms.Y
                if not onButton and not onMenu then
                    open = false
                    menu.Visible = false
                end
            end))

            refresh()
            return control
        end

        function tab:Show()
            activate()
        end

        return tab
    end

    function KNI:Destroy()
        if self._destroyed then return end
        self._destroyed = true
        for _, connection in ipairs(self._connections) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(self._connections)
        if self.Gui then self.Gui:Destroy() end
    end

    return KNI
end)()

-- ═══════════════════════════════════════════════════════════════
-- JUGADOR Y SERVICIOS
-- ═══════════════════════════════════════════════════════════════
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local backpack = player:WaitForChild("Backpack")

-- Limpiar overlays viejos
for _, name in ipairs({ "KNI_DropdownOverlay", "KNI_Notify" }) do
    local old = playerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

-- ═══════════════════════════════════════════════════════════════
-- WHITELIST
-- ═══════════════════════════════════════════════════════════════
local WhitelistURL = "https://pastebin.com/raw/0Ne1DxbB"
local whitelistOk, whitelist = pcall(function()
    return loadstring(game:HttpGet(WhitelistURL, true))()
end)

if not whitelistOk or type(whitelist) ~= "table" then
    player:Kick("[HonenxWhite] Error al verificar whitelist. Contactá al staff.")
    return
end

if not whitelist[player.UserId] then
    player:Kick("[HonenxWhite] No estás autorizado. Unite a discord.gg/bVDtwKF92")
    return
end

print("[HonenxWhite] Whitelist verificada ✅")

-- ═══════════════════════════════════════════════════════════════
-- SERVICIOS GLOBALES
-- ═══════════════════════════════════════════════════════════════
local services = {
    Players          = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    VirtualUser      = game:GetService("VirtualUser"),
    Workspace        = workspace,
    Lighting         = game:GetService("Lighting"),
    UserInputService = game:GetService("UserInputService"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    RunService       = game:GetService("RunService"),
    CollectionService = game:GetService("CollectionService"),
    HttpService      = game:GetService("HttpService"),
    Stats            = game:GetService("Stats"),
}

-- ═══════════════════════════════════════════════════════════════
-- UTILS
-- ═══════════════════════════════════════════════════════════════
local utils = {}
utils.runtime = {}

_G.HonenxWhiteMainConnections = _G.HonenxWhiteMainConnections or {}
for _, connection in ipairs(_G.HonenxWhiteMainConnections) do
    pcall(function() connection:Disconnect() end)
end
_G.HonenxWhiteMainConnections = {}
_G.HonenxWhiteMainGeneration = (_G.HonenxWhiteMainGeneration or 0) + 1
utils.Generation = _G.HonenxWhiteMainGeneration

function utils.isCurrent()
    return utils.Generation == _G.HonenxWhiteMainGeneration
end

function utils.connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(_G.HonenxWhiteMainConnections, connection)
    return connection
end

utils.playerData = {
    Player = player,
    DisplayName = player.DisplayName,
    Character = player.Character,
    Humanoid = nil,
    Camera = services.Workspace.CurrentCamera,
    Backpack = backpack,
}

utils.playerData.Humanoid = utils.playerData.Character
    and utils.playerData.Character:FindFirstChildOfClass("Humanoid")

-- Remotes (con timeout para evitar cuelgues)
utils.remotes = {
    ChangeSpeedSize = services.ReplicatedStorage:WaitForChild("rEvents", 15)
        and services.ReplicatedStorage.rEvents:WaitForChild("changeSpeedSizeRemote", 15),
    MuscleEvent = player:WaitForChild("muscleEvent", 15),
}

function utils.formatNumber(n)
    n = tonumber(n) or 0
    if n >= 1e18 then return string.format("%.1fqi", n / 1e18)
    elseif n >= 1e15 then return string.format("%.1fqa", n / 1e15)
    elseif n >= 1e12 then return string.format("%.1ft", n / 1e12)
    elseif n >= 1e9 then return string.format("%.1fb", n / 1e9)
    elseif n >= 1e6 then return string.format("%.1fm", n / 1e6)
    elseif n >= 1e3 then return string.format("%.1fk", n / 1e3)
    else return tostring(math.floor(n)) end
end

function utils.formatWithCommas(n)
    local s = tostring(math.floor(tonumber(n) or 0))
    while true do
        local newS, count = s:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
        s = newS
        if count == 0 then break end
    end
    return s
end

function utils.notify(title, text, duration, kind)
    KNI.Notify:Show(title, text, duration or 3, kind or "info")
end

function utils.safeFireTouch(partA, partB)
    if not firetouchinterest or not partA or not partB then return end
    pcall(function()
        firetouchinterest(partA, partB, 0)
        firetouchinterest(partA, partB, 1)
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- CREAR VENTANA
-- ═══════════════════════════════════════════════════════════════
local window = KNI.new({
    Name = "HonenxWhite",
    Title = "HonenxWhite | Reborn",
    Width = 620,
    Height = 420,
    -- Cambia 0 por el ID de la imagen subida a Roblox.
    BackgroundImage = KNI_BACKGROUND_IMAGE,
})

_G.HonenxWhiteWindow = window

-- ═══════════════════════════════════════════════════════════════
-- TABS
-- ═══════════════════════════════════════════════════════════════
local tabs = {
    main      = window:AddTab("🏠  Principal"),
    killing   = window:AddTab("⚔️  Combate"),
    specs     = window:AddTab("🎯  Ajustes"),
    farming   = window:AddTab("💪  Entrenamiento"),
    fast      = window:AddTab("⚡  Rápido"),
    boss      = window:AddTab("👹  Jefes"),
    inventory = window:AddTab("🐾  Mascotas"),
    boosts    = window:AddTab("🚀  Mejoras"),
    teleport  = window:AddTab("🌀  Teletransporte"),
    stats     = window:AddTab("📊  Estadísticas"),
    info      = window:AddTab("ℹ️  Información"),
}

for _, tab in pairs(tabs) do
    tab.runtime = {}
end

-- ═══════════════════════════════════════════════════════════════
-- RECONEXIÓN AL CHARACTER
-- ═══════════════════════════════════════════════════════════════
utils.connect(player.CharacterAdded, function(character)
    utils.playerData.Character = character
    utils.playerData.Humanoid = character:WaitForChild("Humanoid", 10)
    utils.playerData.Backpack = player:WaitForChild("Backpack", 10)
end)

-- ═══════════════════════════════════════════════════════════════
-- ANTI-AFK
-- ═══════════════════════════════════════════════════════════════
utils.connect(player.Idled, function()
    pcall(function()
        services.VirtualUser:CaptureController()
        services.VirtualUser:ClickButton2(Vector2.new(0, 0))
        services.VirtualUser:ClickButton1(Vector2.new(0, 0))
    end)
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB MAIN
-- ═══════════════════════════════════════════════════════════════
tabs.main:AddSection("User Settings")

tabs.main.Settings = {
    Size  = { Value = 2,   Enabled = false },
    Speed = { Value = 120, Enabled = false },
    FOV   = { Value = 70,  Enabled = false },
}

tabs.main:AddTextBox("Size (default 2):", function(text)
    text = string.gsub(text, "%s+", "")
    if tonumber(text) and tonumber(text) > 0 then
        tabs.main.Settings.Size.Value = tonumber(text)
    end
end, { clear = false })

tabs.main:AddSwitch("Set Size", function(bool)
    tabs.main.Settings.Size.Enabled = bool
end)

task.spawn(function()
    while utils.isCurrent() do
        if tabs.main.Settings.Size.Enabled
            and utils.playerData.Character and utils.playerData.Humanoid
            and utils.remotes.ChangeSpeedSize then
            pcall(function()
                utils.remotes.ChangeSpeedSize:InvokeServer("changeSize", tabs.main.Settings.Size.Value)
            end)
        end
        task.wait(0.15)
    end
end)

tabs.main:AddTextBox("Speed (default 120):", function(text)
    text = string.gsub(text, "%s+", "")
    if tonumber(text) and tonumber(text) > 0 then
        tabs.main.Settings.Speed.Value = tonumber(text)
    end
end, { clear = false })

tabs.main:AddSwitch("Set Speed", function(bool)
    tabs.main.Settings.Speed.Enabled = bool
end)

task.spawn(function()
    while utils.isCurrent() do
        if tabs.main.Settings.Speed.Enabled
            and utils.playerData.Character and utils.playerData.Humanoid
            and utils.remotes.ChangeSpeedSize then
            pcall(function()
                utils.remotes.ChangeSpeedSize:InvokeServer("changeSpeed", tabs.main.Settings.Speed.Value)
            end)
        end
        task.wait(0.15)
    end
end)

tabs.main:AddTextBox("FOV (1-120):", function(text)
    text = string.gsub(text, "%s+", "")
    if tonumber(text) and tonumber(text) >= 1 and tonumber(text) <= 120 then
        tabs.main.Settings.FOV.Value = tonumber(text)
    end
end, { clear = false })

tabs.main:AddSwitch("Set FOV", function(bool)
    tabs.main.Settings.FOV.Enabled = bool
    if utils.playerData.Camera then
        utils.playerData.Camera.FieldOfView = bool and tabs.main.Settings.FOV.Value or 70
    end
end)

task.spawn(function()
    while utils.isCurrent() do
        if tabs.main.Settings.FOV.Enabled and utils.playerData.Camera then
            utils.playerData.Camera.FieldOfView = tabs.main.Settings.FOV.Value
        end
        task.wait(0.15)
    end
end)

tabs.main:AddSection("Protection & Visuals")

tabs.main.Protection = {
    AntiFling    = { Enabled = false },
    PositionLock = { Enabled = false, Position = nil },
}

tabs.main.enableAntiFling = function()
    if not tabs.main.Protection.AntiFling.Enabled or not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if root:FindFirstChild("BodyVelocity") and root.BodyVelocity.MaxForce == Vector3.new(100000, 0, 100000) then
        root.BodyVelocity:Destroy()
    end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(100000, 0, 100000)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.P = 1250
    bv.Parent = root
    tabs.main.runtime.bv = bv
end

tabs.main.disableAntiFling = function()
    if not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if root:FindFirstChild("BodyVelocity") and root.BodyVelocity.MaxForce == Vector3.new(100000, 0, 100000) then
        root.BodyVelocity:Destroy()
    end
end

tabs.main:AddSwitch("Anti Fling", function(bool)
    tabs.main.Protection.AntiFling.Enabled = bool
    if bool then tabs.main.enableAntiFling() else tabs.main.disableAntiFling() end
end):Set(false)

utils.connect(player.CharacterAdded, function(newChar)
    newChar:WaitForChild("HumanoidRootPart", 5)
    if tabs.main.Protection.AntiFling.Enabled then tabs.main.enableAntiFling() end
end)

tabs.main.lockPosition = function()
    tabs.main.enableAntiFling()
    if not tabs.main.Protection.PositionLock.Enabled or not tabs.main.Protection.PositionLock.Position then return end
    if not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if root:FindFirstChild("PositionLocker") then
        root.PositionLocker.Position = tabs.main.Protection.PositionLock.Position
    else
        tabs.main.disableAntiFling()
        local bp = Instance.new("BodyPosition")
        bp.Name = "PositionLocker"
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.Position = tabs.main.Protection.PositionLock.Position
        bp.P = 100000
        bp.Parent = root
        tabs.main.runtime.bp = bp
    end
end

tabs.main.unlockPosition = function()
    if player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root and root:FindFirstChild("PositionLocker") then
            root.PositionLocker:Destroy()
        end
    end
    tabs.main.Protection.PositionLock.Position = nil
end

tabs.main:AddSwitch("Lock Position", function(bool)
    tabs.main.Protection.PositionLock.Enabled = bool
    if bool then
        if player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then tabs.main.Protection.PositionLock.Position = root.Position end
        end
        tabs.main.lockPosition()
    else
        tabs.main.unlockPosition()
    end
end)

utils.connect(player.CharacterAdded, function(newChar)
    if tabs.main.Protection.PositionLock.Enabled and newChar:WaitForChild("HumanoidRootPart", 5) then
        tabs.main.Protection.PositionLock.Position = newChar.HumanoidRootPart.Position
        tabs.main.lockPosition()
    end
end)

task.spawn(function()
    while utils.isCurrent() do
        if tabs.main.Protection.PositionLock.Enabled then tabs.main.lockPosition() end
        task.wait(0.1)
    end
end)

-- Hide Pets / Popups
tabs.main.VisibilitySettings = {
    HidePets = false,
    HidePopups = false,
}

local rEvents = services.ReplicatedStorage:WaitForChild("rEvents", 15)
tabs.main.VisibilitySettings.ShowPetsEvent = rEvents and rEvents:WaitForChild("showPetsEvent", 5)
tabs.main.VisibilitySettings.SavePlayerSizeEvent = rEvents and rEvents:WaitForChild("savePlayerSizeEvent", 5)

tabs.main:AddSwitch("Hide Pets", function(state)
    tabs.main.VisibilitySettings.HidePets = state
    if tabs.main.VisibilitySettings.ShowPetsEvent then
        tabs.main.VisibilitySettings.ShowPetsEvent:FireServer(state and "hidePets" or "showPets")
    end
end):Set(false)

tabs.main.HidePopupsSwitch = tabs.main:AddSwitch("Hide Popups", function(state)
    tabs.main.VisibilitySettings.HidePopups = state
    if tabs.main.VisibilitySettings.SavePlayerSizeEvent then
        tabs.main.VisibilitySettings.SavePlayerSizeEvent:FireServer("showPopupsOption")
    end
end)
tabs.main.HidePopupsSwitch:Set(false)

-- Redact config
tabs.main.RedactConfigPath = "HonenxWhite/MuscleLegendsMainConfig.json"
tabs.main.RedactConfig = { RedactName = false, RedactStats = false }

tabs.main.loadRedactConfig = function()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return end
    pcall(function()
        if not isfile(tabs.main.RedactConfigPath) then return end
        local savedConfig = services.HttpService:JSONDecode(readfile(tabs.main.RedactConfigPath))
        if typeof(savedConfig) == "table" then
            tabs.main.RedactConfig.RedactName = savedConfig.RedactName == true
            tabs.main.RedactConfig.RedactStats = savedConfig.RedactStats == true
        end
    end)
end

tabs.main.saveRedactConfig = function()
    if type(writefile) ~= "function" then return end
    pcall(function()
        if type(makefolder) == "function"
            and (type(isfolder) ~= "function" or not isfolder("HonenxWhite")) then
            pcall(makefolder, "HonenxWhite")
        end
        writefile(tabs.main.RedactConfigPath, services.HttpService:JSONEncode(tabs.main.RedactConfig))
    end)
end

tabs.main.loadRedactConfig()

tabs.main.RedactNameSwitch = tabs.main:AddSwitch("Redact Name", function(state)
    tabs.main.RedactConfig.RedactName = state
    tabs.main.saveRedactConfig()
end)
tabs.main.RedactNameSwitch:Set(tabs.main.RedactConfig.RedactName)

tabs.main.RedactStatsSwitch = tabs.main:AddSwitch("Redact Stats", function(state)
    tabs.main.RedactConfig.RedactStats = state
    tabs.main.saveRedactConfig()
end)
tabs.main.RedactStatsSwitch:Set(tabs.main.RedactConfig.RedactStats)

-- Walk on Water
tabs.main.WaterParts = {
    Parts = {},
    PartSize = 2048,
    TotalDistance = 50000,
    StartPosition = Vector3.new(-2, -9.5, -2),
}

-- Generación diferida: no crear miles de piezas durante el arranque.
tabs.main.WaterParts.Generating = false
tabs.main.WaterParts.Generated = false
tabs.main.WaterParts.Enabled = false

tabs.main.WaterParts.Generate = function()
    local data = tabs.main.WaterParts
    if data.Generating or data.Generated then return end
    data.Generating = true
    task.spawn(function()
        local steps = math.ceil(data.TotalDistance / data.PartSize) - 1
        local created = 0
        for x = 0, steps do
            if not utils.isCurrent() then break end
            for z = 0, steps do
                if not utils.isCurrent() then break end
                local offsets = {
                    { x * data.PartSize,  z * data.PartSize, "Side_" .. x .. "_" .. z },
                    { -x * data.PartSize, z * data.PartSize, "LeftRight_" .. x .. "_" .. z },
                    { -x * data.PartSize, -z * data.PartSize, "UpLeft_" .. x .. "_" .. z },
                    { x * data.PartSize,  -z * data.PartSize, "UpRight_" .. x .. "_" .. z },
                }
                for _, offset in ipairs(offsets) do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(data.PartSize, 1, data.PartSize)
                    part.Position = data.StartPosition + Vector3.new(offset[1], 0, offset[2])
                    part.Anchored = true
                    part.Transparency = 1
                    part.CanCollide = data.Enabled
                    part.Name = "KNI_Water_" .. offset[3]
                    part.Parent = workspace
                    table.insert(data.Parts, part)
                    created += 1
                    if created % 40 == 0 then task.wait() end
                end
            end
        end
        data.Generated = true
        data.Generating = false
    end)
end

tabs.main.WalkOnWaterSwitch = tabs.main:AddSwitch("Walk on Water", function(bool)
    local data = tabs.main.WaterParts
    data.Enabled = bool
    if bool and not data.Generated then data.Generate() end
    for _, part in ipairs(data.Parts) do
        if part and part.Parent then part.CanCollide = bool end
    end
end)
tabs.main.WalkOnWaterSwitch:Set(false)

tabs.main:AddSection("Other")

tabs.main:AddSwitch("Infinite Jump", function(bool)
    _G.InfiniteJump = bool
    if bool then
        utils.connect(services.UserInputService.JumpRequest, function()
            if _G.InfiniteJump and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid:ChangeState("Jumping") end
            end
        end)
    end
end)

-- Fortune Wheel
tabs.main.FortuneWheelData = {
    Running = false,
    Generation = 0,
    Remote = rEvents and rEvents:WaitForChild("openFortuneWheelRemote", 10),
    Chances = nil,
}

pcall(function()
    local shared = services.ReplicatedStorage:WaitForChild("shared", 10)
    local catalogs = shared and shared:WaitForChild("catalogs", 10)
    local chances = catalogs and catalogs:WaitForChild("fortuneWheelChances", 10)
    if chances then
        tabs.main.FortuneWheelData.Chances = chances:WaitForChild("Fortune Wheel", 10)
    end
end)

tabs.main.spinFortuneWheel = function()
    if not tabs.main.FortuneWheelData.Remote or not tabs.main.FortuneWheelData.Chances then return end
    pcall(function()
        tabs.main.FortuneWheelData.Remote:InvokeServer("openFortuneWheel", tabs.main.FortuneWheelData.Chances)
    end)
end

tabs.main:AddSwitch("Spin Fortune Wheel", function(state)
    tabs.main.FortuneWheelData.Running = state
    tabs.main.FortuneWheelData.Generation += 1
    local generation = tabs.main.FortuneWheelData.Generation
    if not state then return end
    task.spawn(function()
        while utils.isCurrent()
            and tabs.main.FortuneWheelData.Running
            and tabs.main.FortuneWheelData.Generation == generation do
            tabs.main.spinFortuneWheel()
            task.wait(1)
        end
    end)
end)

local timeDropdown = tabs.main:AddDropdown("Change Time", function(selection)
    services.Lighting.ClockTime = selection == "Night" and 0 or 9
end)
timeDropdown:Add("Night")
timeDropdown:Add("Day")

-- ═══════════════════════════════════════════════════════════════
-- TAB INFO
-- ═══════════════════════════════════════════════════════════════
tabs.info:AddSection("Información")
tabs.info:AddLabel("HonenxWhite | Reborn")
tabs.info:AddLabel("Made by Honen / cyanam1 / White")
tabs.info:AddLabel("")

tabs.info:AddButton("📋 Copiar Discord", function()
    if setclipboard then
        setclipboard("https://discord.gg/bVDtwKF92")
        utils.notify("Discord", "Link copiado", 2, "success")
    end
end)

tabs.info:AddLabel("")
tabs.info:AddLabel("Contributors:")
tabs.info:AddLabel("- cyanam1 (@honey)")
tabs.info:AddLabel("- White @chilin6369")
tabs.info:AddLabel("- Honen @Owner")
tabs.info:AddLabel("")
tabs.info:AddLabel("KNI UI - v2.0")

-- ═══════════════════════════════════════════════════════════════
-- TAB KILLING
-- ═══════════════════════════════════════════════════════════════
tabs.killing.getTool = function()
    for _, v in pairs(player.Backpack:GetChildren()) do
        if v.Name == "Punch" and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:EquipTool(v)
        end
    end
    if player:FindFirstChild("muscleEvent") then
        player.muscleEvent:FireServer("punch", "leftHand")
        player.muscleEvent:FireServer("punch", "rightHand")
    end
end

tabs.killing.isPlayerAlive = function(p)
    return p and p.Character
        and p.Character:FindFirstChild("HumanoidRootPart")
        and p.Character:FindFirstChild("Humanoid")
        and p.Character.Humanoid.Health > 0
end

tabs.killing.isSpawnProtected = function(p)
    if not p or not p.Character then return false end
    if p.Character:FindFirstChildOfClass("ForceField")
        or p.Character:FindFirstChild("spawnProtectionHighlight") then
        return true
    end
    local protectedUntil = p.Character:GetAttribute("SpawnProtectedUntil")
    return typeof(protectedUntil) == "number" and workspace:GetServerTimeNow() < protectedUntil
end

tabs.killing.getLocalCombatCharacter = function()
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not humanoid or humanoid.Health <= 0 or not root then return end
    return char, humanoid, root
end

tabs.killing.positionNearTarget = function(target, heightOffset)
    if not tabs.killing.isPlayerAlive(target)
        or tabs.killing.isSpawnProtected(target)
        or tabs.killing.isSpawnProtected(player) then
        return false
    end
    local _, _, localRoot = tabs.killing.getLocalCombatCharacter()
    local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot or not targetRoot then return false end
    localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, heightOffset, 0)
    localRoot.AssemblyLinearVelocity = Vector3.zero
    localRoot.AssemblyAngularVelocity = Vector3.zero
    return true
end

tabs.killing.touchAndPunchTarget = function(target, heightOffset)
    if not tabs.killing.positionNearTarget(target, heightOffset) then return false, false end
    services.RunService.Heartbeat:Wait()
    if not tabs.killing.positionNearTarget(target, heightOffset) then return false, false end

    local char = tabs.killing.getLocalCombatCharacter()
    local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
    if not char or not targetRoot or not targetHumanoid or tabs.killing.isSpawnProtected(target) then
        return false, false
    end

    local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("RightHand")
    if not hand then return false, false end

    local punchTool = char:FindFirstChild("Punch") or player.Backpack:FindFirstChild("Punch")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if punchTool and punchTool.Parent ~= char and humanoid then
        humanoid:EquipTool(punchTool)
    end

    local healthBefore = targetHumanoid.Health
    local attempted = pcall(function()
        utils.safeFireTouch(targetRoot, hand)
        player.muscleEvent:FireServer("punch", hand.Name == "LeftHand" and "leftHand" or "rightHand")
    end)
    if not attempted then return false, false end

    for _ = 1, 4 do
        services.RunService.Heartbeat:Wait()
        if not tabs.killing.isPlayerAlive(target) or targetHumanoid.Health < healthBefore then
            return true, true
        end
        if tabs.killing.isSpawnProtected(target) then
            return false, false
        end
    end

    return false, true
end

tabs.killing.attackPlayerWithLimit = function(target, hitLimit, shouldContinue, heightOffset)
    local hits = 0
    while utils.isCurrent() and hits < hitLimit and shouldContinue()
        and tabs.killing.isPlayerAlive(target)
        and not tabs.killing.isSpawnProtected(target) do
        local hitRegistered, attempted = tabs.killing.touchAndPunchTarget(target, heightOffset)
        if hitRegistered then hits = hits + 1 end
        if not attempted then break end
        if not hitRegistered then task.wait(0.05) end
    end
    return hits
end

tabs.killing.attackPlayerForDuration = function(target, duration, shouldContinue, heightOffset)
    local startedAt = os.clock()
    while utils.isCurrent() and os.clock() - startedAt < duration
        and shouldContinue()
        and tabs.killing.isPlayerAlive(target)
        and not tabs.killing.isSpawnProtected(target) do
        if tabs.killing.positionNearTarget(target, heightOffset) then
            local char = player.Character
            local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            local leftHand = char and char:FindFirstChild("LeftHand")
            local rightHand = char and char:FindFirstChild("RightHand")
            local punchTool = char and char:FindFirstChild("Punch") or player.Backpack:FindFirstChild("Punch")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if punchTool and humanoid and punchTool.Parent ~= char then
                humanoid:EquipTool(punchTool)
            end
            if targetRoot and leftHand and rightHand then
                pcall(function()
                    utils.safeFireTouch(targetRoot, leftHand)
                    utils.safeFireTouch(targetRoot, rightHand)
                    player.muscleEvent:FireServer("punch", "leftHand")
                    player.muscleEvent:FireServer("punch", "rightHand")
                end)
            end
        end
        services.RunService.Heartbeat:Wait()
    end
end

-- Misc
tabs.killing:AddSection("Misc")

tabs.killing.equipBestStatPets = function(priority)
    local petsFolder = player:WaitForChild("petsFolder", 10)
    if not petsFolder then return end
    for _, folder in pairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                pcall(function()
                    services.ReplicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", pet)
                end)
            end
        end
    end
    task.wait(0.2)
    local petsByName = {}
    for _, petName in ipairs(priority) do petsByName[petName] = {} end
    local unique = petsFolder:FindFirstChild("Unique")
    if unique then
        for _, pet in pairs(unique:GetChildren()) do
            if petsByName[pet.Name] then
                table.insert(petsByName[pet.Name], pet)
            end
        end
    end
    local equipped = 0
    for _, petName in ipairs(priority) do
        for _, pet in ipairs(petsByName[petName]) do
            if equipped >= 9 then return end
            pcall(function()
                services.ReplicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
            end)
            equipped = equipped + 1
            task.wait(0.1)
        end
    end
end

tabs.killing:AddButton("Equip Best Damage", function()
    tabs.killing.equipBestStatPets({ "Wild Wizard", "Chaos Sorcerer", "Mighty Monster", "Small Fry" })
end)

tabs.killing:AddButton("Equip Best Health", function()
    tabs.killing.equipBestStatPets({ "Mighty Monster", "Small Fry", "Wild Wizard", "Chaos Sorcerer" })
end)

tabs.killing:AddSwitch("Remove Attack Animations", function(bool)
    if bool then
        local blockedAnimations = {
            ["3638729053"] = true, ["3638767427"] = true, ["507768375"] = true,
            ["522635514"] = true, ["522638767"] = true, ["182393478"] = true,
            ["129967390"] = true, ["129967478"] = true,
        }
        local shouldBlockAnimation = function(track)
            if not track or not track.Animation then return false end
            local animationId = tostring(track.Animation.AnimationId):match("%d+")
            local animationName = string.lower((track.Name or "") .. " " .. (track.Animation.Name or ""))
            return blockedAnimations[animationId] == true
                or string.find(animationName, "punch", 1, true) ~= nil
                or string.find(animationName, "attack", 1, true) ~= nil
                or string.find(animationName, "equip", 1, true) ~= nil
        end
        local isAttackTool = function(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local n = string.lower(tool.Name)
            return string.find(n, "punch", 1, true) ~= nil
        end
        local hasAttackToolEquipped = function(character)
            if not character then return false end
            for _, child in ipairs(character:GetChildren()) do
                if isAttackTool(child) then return true end
            end
            return false
        end
        local stopBlockedAnimations = function(character)
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if shouldBlockAnimation(track) then track:Stop(0) end
            end
        end
        tabs.killing.runtime.animBlockConnection = utils.connect(services.RunService.RenderStepped, function()
            local char = player.Character
            if hasAttackToolEquipped(char) then
                stopBlockedAnimations(char)
            end
        end)
    else
        if tabs.killing.runtime.animBlockConnection then
            tabs.killing.runtime.animBlockConnection:Disconnect()
            tabs.killing.runtime.animBlockConnection = nil
        end
    end
end)

-- Auto Kill
tabs.killing:AddSection("Auto Kill")

_G.whitelistedPlayers = _G.whitelistedPlayers or {}
_G.blacklistedPlayers = _G.blacklistedPlayers or {}

_G.killAll = false
_G.killBlacklistedOnly = false
_G.farmBadKarma = false
_G.farmGoodKarma = false
_G.killAllGeneration = (_G.killAllGeneration or 0) + 1
_G.killListGeneration = (_G.killListGeneration or 0) + 1

tabs.killing.isWhitelisted = function(p)
    for _, name in ipairs(_G.whitelistedPlayers) do
        if name:lower() == p.Name:lower() then return true end
    end
    return false
end

tabs.killing.isBlacklisted = function(p)
    for _, name in ipairs(_G.blacklistedPlayers) do
        if name:lower() == p.Name:lower() then return true end
    end
    return false
end

local function getPlayerList()
    local list = {}
    for _, p in ipairs(services.Players:GetPlayers()) do
        if p ~= player then
            table.insert(list, p.DisplayName .. " | " .. p.Name)
        end
    end
    table.sort(list)
    return list
end

tabs.killing.WhitelistDropdown = tabs.killing:AddDropdown("Add to Whitelist", function(selectedText)
    local playerName = selectedText:match("| (.+)$")
    if playerName then
        playerName = playerName:gsub("^%s*(.-)%s*$", "%1")
        for _, name in ipairs(_G.whitelistedPlayers) do
            if name:lower() == playerName:lower() then return end
        end
        table.insert(_G.whitelistedPlayers, playerName)
        utils.notify("Whitelist", "Añadido: " .. playerName, 2, "success")
    end
end)
for _, item in ipairs(getPlayerList()) do tabs.killing.WhitelistDropdown:Add(item) end

tabs.killing:AddSwitch("Kill Everyone", function(bool)
    _G.killAll = bool
    _G.killAllGeneration = (_G.killAllGeneration or 0) + 1
    local generation = _G.killAllGeneration
    if not bool then return end

    task.spawn(function()
        while utils.isCurrent() and _G.killAll and _G.killAllGeneration == generation do
            local foundTarget = false
            for _, p in ipairs(services.Players:GetPlayers()) do
                if not _G.killAll or _G.killAllGeneration ~= generation then break end
                if p ~= player and not tabs.killing.isWhitelisted(p)
                    and tabs.killing.isPlayerAlive(p) and not tabs.killing.isSpawnProtected(p) then
                    foundTarget = true
                    tabs.killing.attackPlayerForDuration(p, 4, function()
                        return _G.killAll and _G.killAllGeneration == generation and not tabs.killing.isWhitelisted(p)
                    end, 3.5)
                end
            end
            if foundTarget then
                services.RunService.Heartbeat:Wait()
            else
                task.wait(0.1)
            end
        end
    end)
end)

tabs.killing:AddSwitch("Whitelist Friends", function(bool)
    _G.whitelistFriends = bool
    if bool then
        for _, p in pairs(services.Players:GetPlayers()) do
            if p ~= player and p:IsFriendsWith(player.UserId) then
                if not tabs.killing.isWhitelisted(p) then
                    table.insert(_G.whitelistedPlayers, p.Name)
                end
            end
        end
        utils.connect(services.Players.PlayerAdded, function(p)
            if _G.whitelistFriends and p:IsFriendsWith(player.UserId) then
                if not tabs.killing.isWhitelisted(p) then
                    table.insert(_G.whitelistedPlayers, p.Name)
                end
            end
        end)
    end
end)

-- Karma
tabs.killing:AddSection("Karma Killing")

tabs.killing.KarmaData = { FarmEvil = false, FarmGood = false, Generation = 0 }

tabs.killing.matchesKarmaMode = function(p)
    local good = p:FindFirstChild("goodKarma")
    local evil = p:FindFirstChild("evilKarma")
    if not good or not evil then return false end
    local gv, ev = good.Value or 0, evil.Value or 0
    if gv + ev < 5 then return false end
    return (tabs.killing.KarmaData.FarmEvil and gv > ev)
        or (tabs.killing.KarmaData.FarmGood and ev > gv)
end

tabs.killing.restartKarmaWorker = function()
    tabs.killing.KarmaData.Generation += 1
    local generation = tabs.killing.KarmaData.Generation
    if not tabs.killing.KarmaData.FarmEvil and not tabs.killing.KarmaData.FarmGood then return end
    task.spawn(function()
        while utils.isCurrent()
            and (tabs.killing.KarmaData.FarmEvil or tabs.killing.KarmaData.FarmGood)
            and tabs.killing.KarmaData.Generation == generation do
            local foundTarget = false
            for _, p in ipairs(services.Players:GetPlayers()) do
                if tabs.killing.KarmaData.Generation ~= generation then break end
                if p ~= player and not tabs.killing.isWhitelisted(p)
                    and tabs.killing.isPlayerAlive(p) and not tabs.killing.isSpawnProtected(p)
                    and tabs.killing.matchesKarmaMode(p) then
                    foundTarget = true
                    tabs.killing.attackPlayerWithLimit(p, 4, function()
                        return tabs.killing.KarmaData.Generation == generation
                            and not tabs.killing.isWhitelisted(p)
                            and tabs.killing.matchesKarmaMode(p)
                    end, 3.5)
                end
            end
            if foundTarget then
                services.RunService.Heartbeat:Wait()
            else
                task.wait(0.1)
            end
        end
    end)
end

tabs.killing:AddSwitch("Farm Evil Karma", function(state)
    tabs.killing.KarmaData.FarmEvil = state
    tabs.killing.restartKarmaWorker()
end)

tabs.killing:AddSwitch("Farm Good Karma", function(state)
    tabs.killing.KarmaData.FarmGood = state
    tabs.killing.restartKarmaWorker()
end)

-- Target Killing
tabs.killing:AddSection("Target Killing")

tabs.killing.BlacklistDropdown = tabs.killing:AddDropdown("Add to Killlist", function(selectedText)
    local selectedUsername = selectedText:match("| (.+)$")
    if selectedUsername then
        selectedUsername = selectedUsername:gsub("^%s*(.-)%s*$", "%1")
        if not tabs.killing.isBlacklisted({ Name = selectedUsername }) then
            table.insert(_G.blacklistedPlayers, selectedUsername)
            utils.notify("Killlist", "Añadido: " .. selectedUsername, 2, "success")
        end
    end
end)
for _, item in ipairs(getPlayerList()) do tabs.killing.BlacklistDropdown:Add(item) end

utils.connect(services.Players.PlayerAdded, function(p)
    if p ~= player then
        tabs.killing.WhitelistDropdown:Add(p.DisplayName .. " | " .. p.Name)
        tabs.killing.BlacklistDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end)

utils.connect(services.Players.PlayerRemoving, function(p)
    tabs.killing.WhitelistDropdown:Remove(p.DisplayName .. " | " .. p.Name)
    tabs.killing.BlacklistDropdown:Remove(p.DisplayName .. " | " .. p.Name)
end)

tabs.killing:AddSwitch("Kill List", function(bool)
    _G.killBlacklistedOnly = bool
    _G.killListGeneration = (_G.killListGeneration or 0) + 1
    local generation = _G.killListGeneration
    if not bool then return end
    task.spawn(function()
        while utils.isCurrent() and _G.killBlacklistedOnly and _G.killListGeneration == generation do
            local target
            for _, p in ipairs(services.Players:GetPlayers()) do
                if not _G.killBlacklistedOnly or _G.killListGeneration ~= generation then break end
                if p ~= player and tabs.killing.isBlacklisted(p)
                    and tabs.killing.isPlayerAlive(p) and not tabs.killing.isSpawnProtected(p) then
                    target = p
                    break
                end
            end
            if target then
                tabs.killing.touchAndPunchTarget(target, 10)
                services.RunService.Heartbeat:Wait()
            else
                task.wait(0.1)
            end
        end
    end)
end)

-- Spectate
tabs.killing:AddSection("Spectate")

tabs.killing.SpectateData = {
    SelectedPlayer = nil,
    SelectedPlayerUserId = nil,
    Spectating = false,
    CurrentTargetConnection = nil,
    LocalPlayerRespawnConnection = nil,
    CameraMonitorLoop = nil,
}

tabs.killing.stopSpectating = function()
    if tabs.killing.SpectateData.CurrentTargetConnection then
        tabs.killing.SpectateData.CurrentTargetConnection:Disconnect()
        tabs.killing.SpectateData.CurrentTargetConnection = nil
    end
    tabs.killing.SpectateData.CameraMonitorLoop = false
    local localPlayer = services.Players.LocalPlayer
    if localPlayer.Character then
        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and utils.playerData.Camera then
            utils.playerData.Camera.CameraSubject = humanoid
            utils.playerData.Camera.CameraType = Enum.CameraType.Custom
        end
    end
end

tabs.killing.startCameraMonitor = function()
    tabs.killing.SpectateData.CameraMonitorLoop = true
    task.spawn(function()
        while utils.isCurrent() and tabs.killing.SpectateData.CameraMonitorLoop do
            task.wait(0.2)
            if tabs.killing.SpectateData.Spectating and tabs.killing.SpectateData.SelectedPlayer then
                local targetChar = tabs.killing.SpectateData.SelectedPlayer.Character
                if targetChar then
                    local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
                    if targetHumanoid and utils.playerData.Camera then
                        if utils.playerData.Camera.CameraSubject ~= targetHumanoid then
                            utils.playerData.Camera.CameraSubject = targetHumanoid
                        end
                    end
                end
            else
                break
            end
        end
    end)
end

tabs.killing.updateSpectateTarget = function(p)
    if not p then
        if tabs.killing.SpectateData.SelectedPlayerUserId then
            p = services.Players:GetPlayerByUserId(tabs.killing.SpectateData.SelectedPlayerUserId)
            tabs.killing.SpectateData.SelectedPlayer = p
        end
        if not p then
            tabs.killing.stopSpectating()
            return
        end
    end
    tabs.killing.SpectateData.SelectedPlayerUserId = p.UserId
    tabs.killing.SpectateData.SelectedPlayer = p
    if tabs.killing.SpectateData.CurrentTargetConnection then
        tabs.killing.SpectateData.CurrentTargetConnection:Disconnect()
        tabs.killing.SpectateData.CurrentTargetConnection = nil
    end
    local function setCamera(char)
        if not tabs.killing.SpectateData.Spectating
            or tabs.killing.SpectateData.SelectedPlayerUserId ~= p.UserId then return end
        local humanoid = char:WaitForChild("Humanoid", 3)
        if humanoid and tabs.killing.SpectateData.Spectating
            and tabs.killing.SpectateData.SelectedPlayerUserId == p.UserId then
            if utils.playerData.Camera then
                utils.playerData.Camera.CameraSubject = humanoid
            end
        end
    end
    if p.Character then setCamera(p.Character) end
    tabs.killing.SpectateData.CurrentTargetConnection = utils.connect(p.CharacterAdded, function(newChar)
        if tabs.killing.SpectateData.Spectating
            and tabs.killing.SpectateData.SelectedPlayerUserId == p.UserId then
            setCamera(newChar)
        end
    end)
end

tabs.killing.SpectateDropdown = tabs.killing:AddDropdown("Choose Player", function(text)
    for _, p in ipairs(services.Players:GetPlayers()) do
        if text == p.DisplayName .. " | " .. p.Name then
            tabs.killing.SpectateData.SelectedPlayer = p
            tabs.killing.SpectateData.SelectedPlayerUserId = p.UserId
            if tabs.killing.SpectateData.Spectating then
                tabs.killing.updateSpectateTarget(p)
            end
            break
        end
    end
end)
for _, item in ipairs(getPlayerList()) do tabs.killing.SpectateDropdown:Add(item) end

tabs.killing:AddSwitch("Spectate", function(bool)
    tabs.killing.SpectateData.Spectating = bool
    if bool then
        tabs.killing.updateSpectateTarget(tabs.killing.SpectateData.SelectedPlayer)
        tabs.killing.startCameraMonitor()
    else
        tabs.killing.stopSpectating()
    end
end)

utils.connect(services.Players.PlayerAdded, function(p)
    tabs.killing.SpectateDropdown:Add(p.DisplayName .. " | " .. p.Name)
end)

utils.connect(services.Players.PlayerRemoving, function(p)
    tabs.killing.SpectateDropdown:Remove(p.DisplayName .. " | " .. p.Name)
    if p.UserId == tabs.killing.SpectateData.SelectedPlayerUserId then
        tabs.killing.stopSpectating()
    end
end)

-- LocalPlayerRespawn para spectate
tabs.killing.SpectateData.LocalPlayerRespawnConnection = utils.connect(player.CharacterAdded, function(char)
    local humanoid = char:WaitForChild("Humanoid", 3)
    if humanoid then
        utils.playerData.Humanoid = humanoid
    end
    task.wait(0.5)
    if tabs.killing.SpectateData.Spectating then
        tabs.killing.updateSpectateTarget()
        tabs.killing.startCameraMonitor()
    else
        if utils.playerData.Humanoid and utils.playerData.Camera then
            utils.playerData.Camera.CameraSubject = utils.playerData.Humanoid
        end
    end
end)

-- Kill Aura
tabs.killing:AddSection("Kill Aura")

tabs.killing.KillAuraFull = {
    RingPart = nil,
    RingColor = Color3.fromRGB(145, 77, 255),
    RingTransparency = 0.6,
    CenterCFrame = nil,
    Frozen = false,
    Generation = 0,
    Enabled = false,
    Range = 20,
}

_G.showDeathRing = false
_G.deathRingEnabled = false
_G.deathRingRange = 20

local staleRing = workspace:FindFirstChild("HonenxWhiteKillAuraRing")
if staleRing then staleRing:Destroy() end

local ringColors = {
    { Name = "HonenxWhite", Color = Color3.fromRGB(145, 77, 255) },
    { Name = "Red",         Color = Color3.fromRGB(255, 60, 60) },
    { Name = "Orange",      Color = Color3.fromRGB(255, 128, 0) },
    { Name = "Yellow",      Color = Color3.fromRGB(255, 230, 0) },
    { Name = "Lime",        Color = Color3.fromRGB(128, 255, 0) },
    { Name = "Green",       Color = Color3.fromRGB(0, 200, 70) },
    { Name = "Cyan",        Color = Color3.fromRGB(0, 220, 255) },
    { Name = "Blue",        Color = Color3.fromRGB(0, 100, 255) },
    { Name = "Purple",      Color = Color3.fromRGB(145, 70, 255) },
    { Name = "Pink",        Color = Color3.fromRGB(255, 80, 180) },
    { Name = "White",       Color = Color3.fromRGB(255, 255, 255) },
    { Name = "Black",       Color = Color3.fromRGB(0, 0, 0) },
}

local ringColorDropdown = tabs.killing:AddDropdown("Ring Color", function(selection)
    for _, colorData in ipairs(ringColors) do
        if colorData.Name == selection then
            tabs.killing.KillAuraFull.RingColor = colorData.Color
            if tabs.killing.KillAuraFull.RingPart then
                tabs.killing.KillAuraFull.RingPart.Color = colorData.Color
            end
            break
        end
    end
end)
for _, colorData in ipairs(ringColors) do
    ringColorDropdown:Add(colorData.Name)
end

tabs.killing.destroyKillAuraRing = function()
    if tabs.killing.KillAuraFull.RingPart then
        tabs.killing.KillAuraFull.RingPart:Destroy()
        tabs.killing.KillAuraFull.RingPart = nil
    end
end

tabs.killing.createKillAuraRing = function()
    tabs.killing.destroyKillAuraRing()
    local oldRing = workspace:FindFirstChild("HonenxWhiteKillAuraRing")
    if oldRing then oldRing:Destroy() end

    local ring = Instance.new("Part")
    ring.Name = "HonenxWhiteKillAuraRing"
    ring.Shape = Enum.PartType.Cylinder
    ring.Material = Enum.Material.Neon
    ring.Color = tabs.killing.KillAuraFull.RingColor
    ring.Transparency = tabs.killing.KillAuraFull.RingTransparency
    ring.Anchored = true
    ring.CanCollide = false
    ring.CanTouch = false
    ring.CanQuery = false
    ring.CastShadow = false
    ring.Size = Vector3.new(0.2, _G.deathRingRange * 2, _G.deathRingRange * 2)
    if tabs.killing.KillAuraFull.CenterCFrame then
        ring.CFrame = tabs.killing.KillAuraFull.CenterCFrame * CFrame.Angles(0, 0, math.rad(90))
    end
    ring.Parent = workspace
    tabs.killing.KillAuraFull.RingPart = ring
end

tabs.killing.updateKillAuraRing = function()
    if tabs.killing.KillAuraFull.RingPart and tabs.killing.KillAuraFull.CenterCFrame then
        tabs.killing.KillAuraFull.RingPart.CFrame =
            tabs.killing.KillAuraFull.CenterCFrame * CFrame.Angles(0, 0, math.rad(90))
    end
end

tabs.killing.ShowRingSwitch = tabs.killing:AddSwitch("Show Ring", function(bool)
    if bool and not _G.deathRingEnabled then
        _G.showDeathRing = false
        tabs.killing.ShowRingSwitch:Set(false, true)
        return
    end
    _G.showDeathRing = bool
    if bool then
        tabs.killing.createKillAuraRing()
    else
        tabs.killing.destroyKillAuraRing()
    end
end)

tabs.killing:AddSwitch("Toggle Ring (Kill Aura)", function(bool)
    _G.deathRingEnabled = bool
    tabs.killing.KillAuraFull.Enabled = bool
    tabs.killing.KillAuraFull.Generation += 1
    local generation = tabs.killing.KillAuraFull.Generation

    if not bool then
        if tabs.killing.ShowRingSwitch and _G.showDeathRing then
            tabs.killing.ShowRingSwitch:Set(false, true)
        end
        return
    end

    local _, _, initialRoot = tabs.killing.getLocalCombatCharacter()
    if initialRoot then
        tabs.killing.KillAuraFull.CenterCFrame = initialRoot.CFrame
    end

    task.spawn(function()
        while utils.isCurrent()
            and _G.deathRingEnabled
            and tabs.killing.KillAuraFull.Generation == generation do
            local _, _, localRoot = tabs.killing.getLocalCombatCharacter()
            if localRoot and not tabs.killing.KillAuraFull.Frozen then
                tabs.killing.KillAuraFull.CenterCFrame = localRoot.CFrame
            end
            tabs.killing.updateKillAuraRing()
            services.RunService.RenderStepped:Wait()
        end
    end)

    task.spawn(function()
        while utils.isCurrent()
            and _G.deathRingEnabled
            and tabs.killing.KillAuraFull.Generation == generation do
            if tabs.killing.KillAuraFull.Frozen or not tabs.killing.KillAuraFull.CenterCFrame then
                task.wait(0.05)
                continue
            end

            local centerCFrame = tabs.killing.KillAuraFull.CenterCFrame
            local attackedPlayer = false

            for _, targetPlayer in ipairs(services.Players:GetPlayers()) do
                if not _G.deathRingEnabled
                    or tabs.killing.KillAuraFull.Generation ~= generation then break end
                local targetRoot = targetPlayer.Character
                    and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetPlayer ~= player
                    and not tabs.killing.isWhitelisted(targetPlayer)
                    and tabs.killing.isPlayerAlive(targetPlayer)
                    and not tabs.killing.isSpawnProtected(targetPlayer)
                    and targetRoot
                    and (centerCFrame.Position - targetRoot.Position).Magnitude <= _G.deathRingRange then

                    attackedPlayer = true
                    tabs.killing.KillAuraFull.Frozen = true
                    tabs.killing.KillAuraFull.CenterCFrame = centerCFrame
                    tabs.killing.updateKillAuraRing()

                    tabs.killing.attackPlayerWithLimit(targetPlayer, 4, function()
                        local currentTargetRoot = targetPlayer.Character
                            and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        return _G.deathRingEnabled
                            and tabs.killing.KillAuraFull.Generation == generation
                            and not tabs.killing.isWhitelisted(targetPlayer)
                            and currentTargetRoot
                            and (centerCFrame.Position - currentTargetRoot.Position).Magnitude <= _G.deathRingRange
                    end, 3.5)

                    for _ = 1, 4 do
                        local _, _, currentLocalRoot = tabs.killing.getLocalCombatCharacter()
                        if currentLocalRoot then
                            currentLocalRoot.CFrame = centerCFrame
                            currentLocalRoot.AssemblyLinearVelocity = Vector3.zero
                            currentLocalRoot.AssemblyAngularVelocity = Vector3.zero
                        end
                        tabs.killing.KillAuraFull.CenterCFrame = centerCFrame
                        tabs.killing.updateKillAuraRing()
                        services.RunService.Heartbeat:Wait()
                    end
                    tabs.killing.KillAuraFull.Frozen = false
                end
            end

            if not attackedPlayer then
                task.wait(0.05)
            end
        end
        tabs.killing.KillAuraFull.Frozen = false
    end)
end)

tabs.killing:AddSlider("Kill Aura Range", 1, 140, 20, function(value)
    _G.deathRingRange = value
    tabs.killing.KillAuraFull.Range = value
    if tabs.killing.KillAuraFull.RingPart then
        tabs.killing.KillAuraFull.RingPart.Size = Vector3.new(0.2, value * 2, value * 2)
    end
end)

-- Stats
tabs.killing:AddSection("Session Stats")
local killStatsLabel = tabs.killing:AddLabel("Kills: 0")
_G.killSessionStart = nil

task.spawn(function()
    while utils.isCurrent() do
        local ls = player:FindFirstChild("leaderstats")
        local kills = ls and ls:FindFirstChild("Kills")
        if kills and killStatsLabel then
            if not _G.killSessionStart then _G.killSessionStart = kills.Value end
            killStatsLabel:SetText("Kills: " .. utils.formatNumber(kills.Value)
                .. " (Sesión: " .. utils.formatNumber(kills.Value - _G.killSessionStart) .. ")")
        end
        task.wait(1)
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB FARMING
-- ═══════════════════════════════════════════════════════════════
tabs.farming:AddSection("Rebirths")

local leaderstats = player:WaitForChild("leaderstats", 20)

tabs.farming.RebirthData = {
    TargetRebirths = 0,
    IsAutoRebirthing = false,
    Rebirths = leaderstats and leaderstats:WaitForChild("Rebirths", 10),
}

local rebirthLabel = tabs.farming:AddLabel("Rebirths: 0")
local targetLabel = tabs.farming:AddLabel("Target: None")

tabs.farming:AddTextBox("Set Rebirth Target:", function(text)
    if tonumber(text) and tonumber(text) >= 0 then
        tabs.farming.RebirthData.TargetRebirths = tonumber(text)
    end
end)

tabs.farming.RebirthData.Switch = tabs.farming:AddSwitch("Auto Rebirth", function(enabled)
    if enabled and tabs.farming.RebirthData.Rebirths
        and tabs.farming.RebirthData.TargetRebirths > 0
        and tabs.farming.RebirthData.Rebirths.Value < tabs.farming.RebirthData.TargetRebirths then
        tabs.farming.RebirthData.IsAutoRebirthing = true
        task.spawn(function()
            while utils.isCurrent() and tabs.farming.RebirthData.IsAutoRebirthing
                and tabs.farming.RebirthData.Rebirths.Value < tabs.farming.RebirthData.TargetRebirths do
                pcall(function()
                    services.ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                end)
                task.wait(0.1)
            end
            tabs.farming.RebirthData.IsAutoRebirthing = false
            tabs.farming.RebirthData.Switch:Set(false, true)
        end)
    else
        tabs.farming.RebirthData.IsAutoRebirthing = false
    end
end)

task.spawn(function()
    while utils.isCurrent() do
        if rebirthLabel and tabs.farming.RebirthData.Rebirths then
            rebirthLabel:SetText("Rebirths: " .. utils.formatWithCommas(tabs.farming.RebirthData.Rebirths.Value))
        end
        if targetLabel then
            targetLabel:SetText("Target Rebirths: " .. utils.formatWithCommas(tabs.farming.RebirthData.TargetRebirths))
        end
        task.wait(0.5)
    end
end)

-- Auto Size 1
tabs.farming:AddSection("Auto Size")

tabs.farming.SizeData = { Active = false }

tabs.farming.SizeSwitch = tabs.farming:AddSwitch("Auto Size 1", function(bool)
    tabs.farming.SizeData.Active = bool
end)
tabs.farming.SizeSwitch:Set(false)

task.spawn(function()
    while utils.isCurrent() do
        if tabs.farming.SizeData.Active
            and utils.playerData.Character and utils.playerData.Humanoid
            and utils.remotes.ChangeSpeedSize then
            pcall(function()
                utils.remotes.ChangeSpeedSize:InvokeServer("changeSize", 1)
            end)
        end
        task.wait(0.5)
    end
end)

-- Auto King
tabs.farming:AddSection("Auto King")

tabs.farming.KingData = {
    TargetPosition = CFrame.new(-8665.4, 17.21, -5792.9),
    TeleportActive = false,
}

tabs.farming.KingSwitch = tabs.farming:AddSwitch("Auto King", function(enabled)
    tabs.farming.KingData.TeleportActive = enabled
end)

task.spawn(function()
    while utils.isCurrent() do
        if tabs.farming.KingData.TeleportActive then
            local char = utils.playerData.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - tabs.farming.KingData.TargetPosition.Position).Magnitude > 5 then
                    pcall(function()
                        root.CFrame = tabs.farming.KingData.TargetPosition
                    end)
                end
            end
        end
        task.wait(0.1)
    end
end)

-- Auto Exercises
tabs.farming:AddSection("Auto Exercises")

tabs.farming.ExerciseData = {
    SelectedTool = nil,
    AutoFarm = false,
}

local exerciseDropdown = tabs.farming:AddDropdown("Select Exercise", function(selection)
    tabs.farming.ExerciseData.SelectedTool = selection
end)
exerciseDropdown:Add("Weight")
exerciseDropdown:Add("Pushups")
exerciseDropdown:Add("Situps")
exerciseDropdown:Add("Handstands")

tabs.farming.ToolExerciseSwitch = tabs.farming:AddSwitch("Start Exercising", function(enabled)
    tabs.farming.ExerciseData.AutoFarm = enabled
    if enabled then
        task.spawn(function()
            while utils.isCurrent() and tabs.farming.ExerciseData.AutoFarm do
                local char = utils.playerData.Character
                local hum = utils.playerData.Humanoid
                if char and hum and hum.Health > 0 and tabs.farming.ExerciseData.SelectedTool then
                    local tool = char:FindFirstChild(tabs.farming.ExerciseData.SelectedTool)
                        or player.Backpack:FindFirstChild(tabs.farming.ExerciseData.SelectedTool)
                    if tool and tool.Parent ~= char then
                        pcall(function() hum:EquipTool(tool) end)
                    end
                    if tool and tool.Parent == char then
                        pcall(function()
                            player.muscleEvent:FireServer("rep")
                        end)
                    end
                end
                task.wait(0.05)
            end
        end)
    else
        if tabs.farming.ExerciseData.SelectedTool and player.Character then
            local tool = player.Character:FindFirstChild(tabs.farming.ExerciseData.SelectedTool)
            if tool then tool.Parent = player.Backpack end
        end
    end
end)

tabs.farming.AutoRepRunning = false
tabs.farming.AutoRepSwitch = tabs.farming:AddSwitch("Auto Rep", function(state)
    tabs.farming.AutoRepRunning = state
    if not state then return end
    task.spawn(function()
        while utils.isCurrent() and tabs.farming.AutoRepRunning do
            pcall(function()
                player.muscleEvent:FireServer("rep")
            end)
            task.wait(0.1)
        end
    end)
end)

-- Auto Rock
tabs.farming:AddSection("Auto Rock")

tabs.farming.RockData = {
    Data = {
        ["Tiny Rock - 0 Dura"] = 0,
        ["Large Rock - 100 Dura"] = 100,
        ["Punching Rock - 10 Dura"] = 10,
        ["Golden Rock - 5k Dura"] = 5000,
        ["Frost Rock - 150k Dura"] = 150000,
        ["Mythical Rock - 400k Dura"] = 400000,
        ["Eternal Rock - 750k Dura"] = 750000,
        ["Legend Rock - 1m Dura"] = 1000000,
        ["Muscle King Rock - 5m Dura"] = 5000000,
        ["Jungle Rock - 10m Dura"] = 10000000,
        ["Industrial Rock - 25m Dura"] = 25000000,
    },
    SelectedRock = nil,
}

tabs.farming.MachinesFolder = workspace:WaitForChild("machinesFolder", 20)

local rockDropdown = tabs.farming:AddDropdown("Select Rock", function(selection)
    tabs.farming.RockData.SelectedRock = selection
end)
for rockName in pairs(tabs.farming.RockData.Data) do
    rockDropdown:Add(rockName)
end

tabs.farming.RockSwitch = tabs.farming:AddSwitch("Auto Rock", function(enabled)
    _G.RockFarmRunning = enabled
    if not enabled or not tabs.farming.RockData.SelectedRock then return end
    task.spawn(function()
        while utils.isCurrent() and _G.RockFarmRunning do
            task.wait(0.12)
            local char = utils.playerData.Character
            if char and player:FindFirstChild("Durability")
                and player.Durability.Value >= tabs.farming.RockData.Data[tabs.farming.RockData.SelectedRock]
                and tabs.farming.MachinesFolder then
                for _, v in pairs(tabs.farming.MachinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability"
                        and v.Value == tabs.farming.RockData.Data[tabs.farming.RockData.SelectedRock]
                        and char:FindFirstChild("LeftHand") and v.Parent
                        and v.Parent:FindFirstChild("Rock") then
                        pcall(function()
                            utils.safeFireTouch(v.Parent.Rock, char.RightHand)
                            utils.safeFireTouch(v.Parent.Rock, char.LeftHand)
                            tabs.killing.getTool()
                        end)
                    end
                end
            end
        end
    end)
end)

-- Auto Squat / Lift con máquinas
tabs.farming.SquatsByName = {}
tabs.farming.SquatMachineNames = {}
tabs.farming.LiftMachineNames = {}

tabs.farming.MachineExerciseData = {
    Squat = { SelectedMachine = nil, ActiveMachine = nil, Running = false, Generation = 0, ReenterAt = 0, SeatPart = nil, Choices = {} },
    Lift  = { SelectedMachine = nil, ActiveMachine = nil, Running = false, Generation = 0, ReenterAt = 0, SeatPart = nil, Choices = {} },
}

if tabs.farming.MachinesFolder then
    for _, machine in ipairs(tabs.farming.MachinesFolder:GetChildren()) do
        local lowerName = string.lower(machine.Name)
        if string.find(lowerName, "squat", 1, true) and lowerName ~= "squat rack" then
            tabs.farming.SquatsByName[machine.Name] = tabs.farming.SquatsByName[machine.Name] or {}
            table.insert(tabs.farming.SquatsByName[machine.Name], machine)
        elseif string.find(lowerName, "lift", 1, true) and lowerName ~= "deadlift" then
            tabs.farming.MachineExerciseData.Lift.Choices[machine.Name] = machine
            table.insert(tabs.farming.LiftMachineNames, machine.Name)
        end
    end
end

for machineName, matchingSquats in pairs(tabs.farming.SquatsByName) do
    tabs.farming.MachineExerciseData.Squat.Choices[machineName] = matchingSquats[1]
    table.insert(tabs.farming.SquatMachineNames, machineName)
end

table.sort(tabs.farming.SquatMachineNames)
table.sort(tabs.farming.LiftMachineNames)

tabs.farming.getMachineInteractPart = function(machine)
    for _, descendant in ipairs(machine:GetDescendants()) do
        if descendant:IsA("BasePart") and string.lower(descendant.Name) == "interactseat" then
            return descendant
        end
    end
end

tabs.farming.enterExerciseMachine = function(machine)
    if not machine or not machine.Parent then return false end
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    local interactPart = tabs.farming.getMachineInteractPart(machine)
    if not humanoidRootPart or not interactPart then return false end

    humanoidRootPart.CFrame = interactPart.CFrame * CFrame.new(0, 3, 0)
    humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
    task.wait(0.4)
    services.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    services.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    task.wait(0.4)
    return true
end

tabs.farming.startMachineExercise = function(machineData)
    machineData.Generation += 1
    local generation = machineData.Generation
    local lastCharacter = player.Character

    task.spawn(function()
        while utils.isCurrent() and machineData.Running and machineData.Generation == generation do
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if character ~= lastCharacter then
                lastCharacter = character
                machineData.ActiveMachine = nil
                machineData.SeatPart = nil
                machineData.ReenterAt = os.clock() + 3.5
            end

            if not character or not humanoid or humanoid.Health <= 0 then
                machineData.ActiveMachine = nil
                machineData.SeatPart = nil
                machineData.ReenterAt = math.max(machineData.ReenterAt, os.clock() + 3.5)
                task.wait(0.1)
                continue
            end

            local humanoidState = humanoid:GetState()
            local jumpedOff = machineData.ActiveMachine and (
                humanoidState == Enum.HumanoidStateType.Jumping
                or humanoidState == Enum.HumanoidStateType.Freefall
                or (machineData.SeatPart and humanoid.SeatPart ~= machineData.SeatPart)
            )

            if jumpedOff then
                machineData.ActiveMachine = nil
                machineData.SeatPart = nil
                machineData.ReenterAt = os.clock() + 3.5
            end

            if machineData.SelectedMachine and not machineData.ActiveMachine and os.clock() >= machineData.ReenterAt then
                if tabs.farming.enterExerciseMachine(machineData.SelectedMachine) then
                    machineData.ActiveMachine = machineData.SelectedMachine
                    machineData.SeatPart = humanoid.SeatPart
                end
            end

            task.wait(0.1)
        end
    end)
end

tabs.farming.setMachineExerciseState = function(machineData, otherMachineData, state)
    machineData.Running = state
    machineData.Generation += 1
    local generation = machineData.Generation
    machineData.ActiveMachine = nil
    machineData.SeatPart = nil
    machineData.ReenterAt = 0

    if not state then return end
    if tabs.farming.ToolExerciseSwitch and tabs.farming.ExerciseData.AutoFarm then
        tabs.farming.ToolExerciseSwitch:Set(false, true)
    end
    if otherMachineData.Running then
        if machineData == tabs.farming.MachineExerciseData.Squat and tabs.farming.LiftExerciseSwitch then
            tabs.farming.LiftExerciseSwitch:Set(false, true)
        elseif machineData == tabs.farming.MachineExerciseData.Lift and tabs.farming.SquatExerciseSwitch then
            tabs.farming.SquatExerciseSwitch:Set(false, true)
        end
    end
    tabs.farming.startMachineExercise(machineData)
    task.spawn(function()
        while utils.isCurrent() and machineData.Running and machineData.Generation == generation do
            if machineData.ActiveMachine then
                pcall(function()
                    player.muscleEvent:FireServer("rep")
                end)
            end
            task.wait(0.1)
        end
    end)
end

local squatDropdown = tabs.farming:AddDropdown("Select Squat", function(selection)
    tabs.farming.MachineExerciseData.Squat.SelectedMachine = tabs.farming.MachineExerciseData.Squat.Choices[selection]
    tabs.farming.MachineExerciseData.Squat.ActiveMachine = nil
    tabs.farming.MachineExerciseData.Squat.SeatPart = nil
    tabs.farming.MachineExerciseData.Squat.ReenterAt = 0
end)
for _, machineName in ipairs(tabs.farming.SquatMachineNames) do
    squatDropdown:Add(machineName)
end

tabs.farming.SquatExerciseSwitch = tabs.farming:AddSwitch("Auto Squat", function(state)
    tabs.farming.setMachineExerciseState(
        tabs.farming.MachineExerciseData.Squat,
        tabs.farming.MachineExerciseData.Lift,
        state
    )
end)

local liftDropdown = tabs.farming:AddDropdown("Select Lift", function(selection)
    tabs.farming.MachineExerciseData.Lift.SelectedMachine = tabs.farming.MachineExerciseData.Lift.Choices[selection]
    tabs.farming.MachineExerciseData.Lift.ActiveMachine = nil
    tabs.farming.MachineExerciseData.Lift.SeatPart = nil
    tabs.farming.MachineExerciseData.Lift.ReenterAt = 0
end)
for _, machineName in ipairs(tabs.farming.LiftMachineNames) do
    liftDropdown:Add(machineName)
end

tabs.farming.LiftExerciseSwitch = tabs.farming:AddSwitch("Auto Lift", function(state)
    tabs.farming.setMachineExerciseState(
        tabs.farming.MachineExerciseData.Lift,
        tabs.farming.MachineExerciseData.Squat,
        state
    )
end)

-- Leave Exercise Machine
tabs.farming.leaveExerciseMachine = function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or humanoid.Health <= 0 then return end

    pcall(function()
        services.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        humanoid.Sit = false
        humanoid.Jump = true
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        if root then
            root.AssemblyLinearVelocity = Vector3.new(0, math.max(root.AssemblyLinearVelocity.Y, 50), 0)
        end
    end)
    pcall(function()
        services.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
    task.wait(0.2)
end

-- Better Strength Farming
tabs.farming:AddSection("Better Strength Farming")

tabs.farming.Configs = {
    { name = "Pushup + Industrial Rock", tool = "Pushups", rock = "Industrial Rock" },
    { name = "Pushup + Jungle Rock", tool = "Pushups", rock = "Ancient Jungle Rock" },
    { name = "Pushup + Muscle King Rock", tool = "Pushups", rock = "Muscle King Mountain" },
    { name = "Pushup + Legends Rock", tool = "Pushups", rock = "Rock Of Legends" },
}
tabs.farming.ActiveConfigs = {}

for _, config in ipairs(tabs.farming.Configs) do
    tabs.farming.ActiveConfigs[config.name] = false
    config.Switch = tabs.farming:AddSwitch(config.name, function(state)
        tabs.farming.ActiveConfigs[config.name] = state
        if tabs.farming.ActiveConfigs[config.name] then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local backpackTool = player.Backpack:FindFirstChild(config.tool)
                if backpackTool and humanoid and not character:FindFirstChild(config.tool) then
                    humanoid:EquipTool(backpackTool)
                end
            end
            task.spawn(function()
                while utils.isCurrent() and tabs.farming.ActiveConfigs[config.name] do
                    pcall(function()
                        player.muscleEvent:FireServer("rep")
                    end)
                    local char = player.Character
                    if char and tabs.farming.MachinesFolder
                        and tabs.farming.MachinesFolder:FindFirstChild(config.rock) then
                        local rockFolder = tabs.farming.MachinesFolder:FindFirstChild(config.rock)
                        local rock = rockFolder and rockFolder:FindFirstChild("Rock")
                        local leftHand = char:FindFirstChild("LeftHand")
                        if rock and leftHand then
                            utils.safeFireTouch(rock, leftHand)
                        end
                    end
                    if char and player.Backpack:FindFirstChild("Punch") then
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:EquipTool(player.Backpack.Punch)
                            pcall(function()
                                player.muscleEvent:FireServer("punch", "rightHand")
                                player.muscleEvent:FireServer("punch", "leftHand")
                            end)
                        end
                    end
                    services.RunService.RenderStepped:Wait()
                    local char2 = player.Character
                    if char2 and player.Backpack:FindFirstChild(config.tool) then
                        local humanoid2 = char2:FindFirstChildOfClass("Humanoid")
                        if humanoid2 then
                            humanoid2:EquipTool(player.Backpack[config.tool])
                        end
                    end
                end
            end)
        else
            local char = player.Character
            if char and char:FindFirstChild(config.tool) then
                char[config.tool].Parent = player.Backpack
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- TAB FAST
-- ═══════════════════════════════════════════════════════════════

-- Fast Rep
tabs.fast:AddSection("Fast Rep")

tabs.fast.FastRepData = {
    Running = false,
    WorkerActive = false,
    RepsPerCycle = 20,
}

local fastRepStatus = tabs.fast:AddLabel("Status: Inactive")

tabs.fast.FastRepWorkerLoop = function()
    if tabs.fast.FastRepData.WorkerActive then return end
    tabs.fast.FastRepData.WorkerActive = true
    local data = tabs.fast.FastRepData
    local interval = 1 / 40
    while utils.isCurrent() and data.Running do
        pcall(function()
            for _ = 1, data.RepsPerCycle do
                player.muscleEvent:FireServer("rep")
            end
        end)
        if fastRepStatus then fastRepStatus:SetText("Status: 800 reps/s (MAX)") end
        task.wait(interval)
    end
    data.WorkerActive = false
end

tabs.fast:AddTextBox("Reps por ciclo (1-20):", function(text)
    local num = tonumber(text)
    if num and num >= 1 then
        tabs.fast.FastRepData.RepsPerCycle = math.clamp(math.floor(num), 1, 20)
    end
end)

tabs.fast.FastRepToggle = tabs.fast:AddSwitch("Fast Rep (Ultra Rápido)", function(state)
    local data = tabs.fast.FastRepData
    data.Running = state
    if state then
        if fastRepStatus then fastRepStatus:SetText("Status: Activando...") end
        if not data.WorkerActive then
            task.spawn(tabs.fast.FastRepWorkerLoop)
        end
    else
        if fastRepStatus then fastRepStatus:SetText("Status: Inactive") end
    end
end)

-- Ultra Fast Rep 20K
tabs.fast:AddSection("Ultra Fast Rep 20K")

local UltraState = {
    Enabled = false,
    WorkerActive = false,
    RepsPerCycle = 200,
    CycleDelay = 0.01,
    TotalReps = 0,
}
_G.HonenxWhiteUltraFastRep = UltraState

task.spawn(function()
    if UltraState.WorkerActive then return end
    UltraState.WorkerActive = true
    while utils.isCurrent() do
        if UltraState.Enabled then
            local muscle = player:FindFirstChild("muscleEvent")
            if muscle then
                local start = os.clock()
                for _ = 1, UltraState.RepsPerCycle do
                    if not UltraState.Enabled then break end
                    pcall(function() muscle:FireServer("rep") end)
                    UltraState.TotalReps = UltraState.TotalReps + 1
                end
                local elapsed = os.clock() - start
                local sleepTime = UltraState.CycleDelay - elapsed
                if sleepTime > 0 then task.wait(sleepTime) else task.wait() end
            else
                task.wait(0.05)
            end
        else
            task.wait(0.1)
        end
    end
end)

tabs.fast:AddSwitch("🚀 Ultra Fast Rep (20000 reps/s)", function(state)
    UltraState.Enabled = state
    if state then
        UltraState.TotalReps = 0
        utils.notify("Ultra Fast Rep", "🚀 ACTIVADO - 20,000 reps/s", 3, "success")
    else
        utils.notify("Ultra Fast Rep", "⏸️ Desactivado", 2, "info")
    end
end)

-- Fast Rebirth
tabs.fast:AddSection("Fast Rebirth")

tabs.fast.FastRebirthData = {
    Running = false,
    WorkerActive = false,
    Rebirths = leaderstats and leaderstats:WaitForChild("Rebirths", 10),
    Strength = leaderstats and leaderstats:WaitForChild("Strength", 10),
    TargetRebirths = 0,
    TotalRebirths = 0,
}

local fastRebirthStatus = tabs.fast:AddLabel("Status: Inactive")
local fastRebirthStats = tabs.fast:AddLabel("Rebirths: 0 | Gained: 0")

tabs.fast.FastRebirthWorker = function()
    if not tabs.fast.FastRebirthData.Rebirths or not tabs.fast.FastRebirthData.Strength then return end
    local startRebirths = tabs.fast.FastRebirthData.Rebirths.Value
    tabs.fast.FastRebirthData.TotalRebirths = 0

    while utils.isCurrent() and tabs.fast.FastRebirthData.Running do
        if tabs.fast.FastRebirthData.TargetRebirths > 0
            and tabs.fast.FastRebirthData.Rebirths.Value >= tabs.fast.FastRebirthData.TargetRebirths then
            fastRebirthStatus:SetText("Status: ✅ Target alcanzado!")
            tabs.fast.FastRebirthData.Running = false
            break
        end

        local currentRebirths = tabs.fast.FastRebirthData.Rebirths.Value
        local targetStrength = 5000 + currentRebirths * 2550
        local repsPerBurst = player.MembershipType == Enum.MembershipType.Premium and 3 or 4

        fastRebirthStatus:SetText("Status: 💪 Farmeando... "
            .. utils.formatNumber(tabs.fast.FastRebirthData.Strength.Value)
            .. " / " .. utils.formatNumber(targetStrength))

        while utils.isCurrent() and tabs.fast.FastRebirthData.Running
            and tabs.fast.FastRebirthData.Strength.Value < targetStrength do
            for _ = 1, repsPerBurst do
                pcall(function()
                    player.muscleEvent:FireServer("rep")
                end)
            end
            task.wait(0.05)
            fastRebirthStats:SetText("Rebirths: "
                .. utils.formatWithCommas(tabs.fast.FastRebirthData.Rebirths.Value)
                .. " | Gained: "
                .. utils.formatWithCommas(tabs.fast.FastRebirthData.Rebirths.Value - startRebirths))
        end

        if utils.isCurrent() and tabs.fast.FastRebirthData.Running
            and tabs.fast.FastRebirthData.Strength.Value >= targetStrength then
            fastRebirthStatus:SetText("Status: 🔄 Haciendo rebirth...")
            local rebirthValueBefore = tabs.fast.FastRebirthData.Rebirths.Value
            local attempts = 0
            repeat
                pcall(function()
                    services.ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                end)
                task.wait(0.12)
                attempts = attempts + 1
            until not tabs.fast.FastRebirthData.Running
                or tabs.fast.FastRebirthData.Rebirths.Value > rebirthValueBefore
                or attempts >= 50
            if tabs.fast.FastRebirthData.Rebirths.Value > rebirthValueBefore then
                tabs.fast.FastRebirthData.TotalRebirths = tabs.fast.FastRebirthData.TotalRebirths
                    + (tabs.fast.FastRebirthData.Rebirths.Value - rebirthValueBefore)
            end
        end
        task.wait(0.3)
    end
    tabs.fast.FastRebirthData.WorkerActive = false
end

tabs.fast:AddTextBox("Target rebirths (0 = infinito):", function(text)
    local num = tonumber(text)
    if num and num >= 0 then
        tabs.fast.FastRebirthData.TargetRebirths = math.floor(num)
    end
end)

tabs.fast.FastRebirthToggle = tabs.fast:AddSwitch("Fast Rebirth 🔄", function(state)
    tabs.fast.FastRebirthData.Running = state
    if state then
        fastRebirthStatus:SetText("Status: 🔄 Iniciando...")
        if not tabs.fast.FastRebirthData.WorkerActive then
            tabs.fast.FastRebirthData.WorkerActive = true
            task.spawn(tabs.fast.FastRebirthWorker)
        end
    else
        fastRebirthStatus:SetText("Status: Inactive")
    end
end)

-- Helpers de equipar pets para Ultra/Chaos
tabs.fast.desequipAll = function()
    local petsFolder = player:FindFirstChild("petsFolder")
    if not petsFolder then return end
    for _, folder in pairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                pcall(function()
                    services.ReplicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", pet)
                end)
            end
        end
    end
    if player.Character then
        for _, obj in pairs(player.Character:GetChildren()) do
            if obj:IsA("StringValue") or obj:IsA("ObjectValue") then
                pcall(function()
                    services.ReplicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", obj)
                end)
            end
        end
    end
    task.wait(0.3)
end

tabs.fast.equipPets = function(petNames)
    local petsFolder = player:FindFirstChild("petsFolder")
    if not petsFolder then return 0 end
    local uniquePets = petsFolder:FindFirstChild("Unique")
    if not uniquePets then return 0 end
    tabs.fast.desequipAll()
    task.wait(0.2)
    local equipped = 0
    for _, petName in ipairs(petNames) do
        for _, pet in pairs(uniquePets:GetChildren()) do
            if pet.Name == petName then
                pcall(function()
                    services.ReplicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
                end)
                equipped = equipped + 1
                task.wait(0.05)
            end
        end
    end
    task.wait(0.3)
    return equipped
end

-- Ultra Titans
tabs.fast:AddSection("Ultra Titans Pack")

tabs.fast.UltraData = {
    Running = false,
    WorkerActive = false,
    Rebirths = leaderstats and leaderstats:WaitForChild("Rebirths", 10),
    Strength = leaderstats and leaderstats:WaitForChild("Strength", 10),
    TargetRebirths = 0,
    TotalRebirths = 0,
    RepPets = { "Omega Overlord" },
    RebirthPets = { "Titanium Hydra" },
}

local ultraStatus = tabs.fast:AddLabel("Status: Inactive")
local ultraStats = tabs.fast:AddLabel("Rebirths: 0 | Gained: 0")

tabs.fast.UltraWorker = function()
    if not tabs.fast.UltraData.Rebirths or not tabs.fast.UltraData.Strength then return end
    local startRebirths = tabs.fast.UltraData.Rebirths.Value

    while utils.isCurrent() and tabs.fast.UltraData.Running do
        if tabs.fast.UltraData.TargetRebirths > 0
            and tabs.fast.UltraData.Rebirths.Value >= tabs.fast.UltraData.TargetRebirths then
            ultraStatus:SetText("Status: Target alcanzado")
            tabs.fast.UltraData.Running = false
            break
        end

        ultraStatus:SetText("Status: Equipando Rep...")
        local equippedRep = 0
        pcall(function() equippedRep = tabs.fast.equipPets(tabs.fast.UltraData.RepPets) end)
        ultraStatus:SetText("Status: " .. equippedRep .. " Rep equipados")

        local currentRebirths = tabs.fast.UltraData.Rebirths.Value
        local targetStrength = 5000 + currentRebirths * 2550
        local repsPerBurst = player.MembershipType == Enum.MembershipType.Premium and 6 or 12

        ultraStatus:SetText("Status: Farmeando...")
        while utils.isCurrent() and tabs.fast.UltraData.Running
            and tabs.fast.UltraData.Strength.Value < targetStrength do
            pcall(function()
                for _ = 1, repsPerBurst do
                    player.muscleEvent:FireServer("rep")
                end
            end)
            task.wait(0.05)
            ultraStats:SetText("Rebirths: "
                .. utils.formatWithCommas(tabs.fast.UltraData.Rebirths.Value)
                .. " | Gained: "
                .. utils.formatWithCommas(tabs.fast.UltraData.Rebirths.Value - startRebirths))
        end

        if utils.isCurrent() and tabs.fast.UltraData.Running
            and tabs.fast.UltraData.Strength.Value >= targetStrength then
            ultraStatus:SetText("Status: Equipando Hydra...")
            local equippedReb = 0
            pcall(function() equippedReb = tabs.fast.equipPets(tabs.fast.UltraData.RebirthPets) end)
            ultraStatus:SetText("Status: " .. equippedReb .. " Hydra equipadas")
            task.wait(0.5)

            ultraStatus:SetText("Status: Haciendo Rebirth...")
            local rebirthBefore = tabs.fast.UltraData.Rebirths.Value
            local attempts = 0
            repeat
                pcall(function()
                    services.ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                end)
                task.wait(0.05)
                attempts = attempts + 1
            until not tabs.fast.UltraData.Running
                or tabs.fast.UltraData.Rebirths.Value > rebirthBefore
                or attempts >= 50
            if tabs.fast.UltraData.Rebirths.Value > rebirthBefore then
                tabs.fast.UltraData.TotalRebirths = tabs.fast.UltraData.TotalRebirths
                    + (tabs.fast.UltraData.Rebirths.Value - rebirthBefore)
            end
            task.wait(0.5)
        end
        task.wait(0.1)
    end
    tabs.fast.UltraData.WorkerActive = false
end

tabs.fast:AddTextBox("Ultra - Target rebirths (0 = inf):", function(text)
    local num = tonumber(text)
    if num and num >= 0 then
        tabs.fast.UltraData.TargetRebirths = math.floor(num)
    end
end, { clear = false })

tabs.fast.UltraToggle = tabs.fast:AddSwitch("Fast Rebirth Ultra Titans", function(state)
    tabs.fast.UltraData.Running = state
    if state then
        ultraStatus:SetText("Status: Iniciando Ultra...")
        if not tabs.fast.UltraData.WorkerActive then
            tabs.fast.UltraData.WorkerActive = true
            task.spawn(tabs.fast.UltraWorker)
        end
    else
        ultraStatus:SetText("Status: Inactive")
    end
end)

tabs.fast:AddLabel("Omega Overlord > Farm > Titanium Hydra > Rebirth")

-- Chaos Overlords
tabs.fast:AddSection("Chaos Overlords Pack")

tabs.fast.ChaosData = {
    Running = false,
    WorkerActive = false,
    Rebirths = leaderstats and leaderstats:WaitForChild("Rebirths", 10),
    Strength = leaderstats and leaderstats:WaitForChild("Strength", 10),
    TargetRebirths = 0,
    TotalRebirths = 0,
    RepPets = { "Swift Samurai" },
    RebirthPets = { "Tribal Overlord" },
}

local chaosStatus = tabs.fast:AddLabel("Status: Inactive")
local chaosStats = tabs.fast:AddLabel("Rebirths: 0 | Gained: 0")

tabs.fast.ChaosWorker = function()
    if not tabs.fast.ChaosData.Rebirths or not tabs.fast.ChaosData.Strength then return end
    local startRebirths = tabs.fast.ChaosData.Rebirths.Value

    while utils.isCurrent() and tabs.fast.ChaosData.Running do
        if tabs.fast.ChaosData.TargetRebirths > 0
            and tabs.fast.ChaosData.Rebirths.Value >= tabs.fast.ChaosData.TargetRebirths then
            chaosStatus:SetText("Status: Target alcanzado")
            tabs.fast.ChaosData.Running = false
            break
        end

        chaosStatus:SetText("Status: Equipando Rep...")
        local equippedRep = 0
        pcall(function() equippedRep = tabs.fast.equipPets(tabs.fast.ChaosData.RepPets) end)
        chaosStatus:SetText("Status: " .. equippedRep .. " Rep equipados")

        local currentRebirths = tabs.fast.ChaosData.Rebirths.Value
        local targetStrength = 5000 + currentRebirths * 2550
        local repsPerBurst = player.MembershipType == Enum.MembershipType.Premium and 6 or 12

        chaosStatus:SetText("Status: Farmeando...")
        while utils.isCurrent() and tabs.fast.ChaosData.Running
            and tabs.fast.ChaosData.Strength.Value < targetStrength do
            pcall(function()
                for _ = 1, repsPerBurst do
                    player.muscleEvent:FireServer("rep")
                end
            end)
            task.wait(0.05)
            chaosStats:SetText("Rebirths: "
                .. utils.formatWithCommas(tabs.fast.ChaosData.Rebirths.Value)
                .. " | Gained: "
                .. utils.formatWithCommas(tabs.fast.ChaosData.Rebirths.Value - startRebirths))
        end

        if utils.isCurrent() and tabs.fast.ChaosData.Running
            and tabs.fast.ChaosData.Strength.Value >= targetStrength then
            chaosStatus:SetText("Status: Equipando Tribal...")
            local equippedReb = 0
            pcall(function() equippedReb = tabs.fast.equipPets(tabs.fast.ChaosData.RebirthPets) end)
            chaosStatus:SetText("Status: " .. equippedReb .. " Tribal equipados")
            task.wait(0.5)

            chaosStatus:SetText("Status: Haciendo Rebirth...")
            local rebirthBefore = tabs.fast.ChaosData.Rebirths.Value
            local attempts = 0
            repeat
                pcall(function()
                    services.ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                end)
                task.wait(0.05)
                attempts = attempts + 1
            until not tabs.fast.ChaosData.Running
                or tabs.fast.ChaosData.Rebirths.Value > rebirthBefore
                or attempts >= 50
            if tabs.fast.ChaosData.Rebirths.Value > rebirthBefore then
                tabs.fast.ChaosData.TotalRebirths = tabs.fast.ChaosData.TotalRebirths
                    + (tabs.fast.ChaosData.Rebirths.Value - rebirthBefore)
            end
            task.wait(0.5)
        end
        task.wait(0.1)
    end
    tabs.fast.ChaosData.WorkerActive = false
end

tabs.fast:AddTextBox("Chaos - Target rebirths (0 = inf):", function(text)
    local num = tonumber(text)
    if num and num >= 0 then
        tabs.fast.ChaosData.TargetRebirths = math.floor(num)
    end
end, { clear = false })

tabs.fast.ChaosToggle = tabs.fast:AddSwitch("Fast Rebirth Chaos Overlords", function(state)
    tabs.fast.ChaosData.Running = state
    if state then
        chaosStatus:SetText("Status: Iniciando Chaos...")
        if not tabs.fast.ChaosData.WorkerActive then
            tabs.fast.ChaosData.WorkerActive = true
            task.spawn(tabs.fast.ChaosWorker)
        end
    else
        chaosStatus:SetText("Status: Inactive")
    end
end)

tabs.fast:AddLabel("Swift Samurai > Farm > Tribal Overlord > Rebirth")

-- ═══════════════════════════════════════════════════════════════
-- TAB BOSS
-- ═══════════════════════════════════════════════════════════════
tabs.boss:AddSection("Boss Farming")

local bossStatusLabel = tabs.boss:AddLabel("Status: Waiting for Boss")
local bossLabel = tabs.boss:AddLabel("Boss: None")
local bossHealthLabel = tabs.boss:AddLabel("Health: 0 / 0")
local nextBossLabel = tabs.boss:AddLabel("Next Boss: N/A")

-- Única inicialización de tabs.boss.Data (sin pisarlo después)
tabs.boss.Data = {
    Running = false,
    ActiveMode = nil,
    Generation = 0,
    ContinueTraining = false,
    Phase = "Waiting",
    PunchInterval = 0.3,
    LastPunch = 0,
    Bosses = {},
    BossOrder = {},
    BossByDisplayName = {},
    SelectedBosses = {},
    AttackSequence = nil,
    EvadeUntil = 0,
    EvadeDistance = 230,
    PunchBehindDistance = 45,
    StompHealthThreshold = 0.35,
    DodgeStomps = false,
    TrainingSnapshot = nil,
    SpecialBosses = {
        ["Grim Reaper"] = true,
        ["Frankenbrute"] = true,
        ["Pumpkin Titan"] = true,
        ["Scarecrow Colossus"] = true,
    },
    SpecialBossOrder = {
        "Grim Reaper",
        "Frankenbrute",
        "Pumpkin Titan",
        "Scarecrow Colossus",
    },
    SpecialBossByDisplayName = {},
}

tabs.boss.getBossHealth = function(health)
    if health then
        if health:IsA("Humanoid") then return health.Health end
        local ok, value = pcall(function() return health.Value end)
        if ok and tonumber(value) then return tonumber(value) end
    end
    return workspace:GetAttribute("BossHealth") or 0
end

tabs.boss.getBossMaxHealth = function(maxHealth)
    if maxHealth then
        if maxHealth:IsA("Humanoid") then return maxHealth.MaxHealth end
        local ok, value = pcall(function() return maxHealth.Value end)
        if ok and tonumber(value) then return tonumber(value) end
    end
    return workspace:GetAttribute("BossMaxHealth") or 0
end

tabs.boss.getBossHeadPosition = function(model, hitbox)
    local head = model:FindFirstChild("Head", true) or model:FindFirstChild("head", true)
    if head and head:IsA("BasePart") then return head.Position end
    return hitbox.Position + Vector3.new(0, hitbox.Size.Y * 0.35, 0)
end

-- Selector de rarezas
tabs.boss:AddSection("Target Specific Bosses")
local selectedBossesLabel = tabs.boss:AddLabel("Targeted Bosses: Detecting...")

tabs.boss.BossDropdown = tabs.boss:AddDropdown("Target specific Bosses", function(displayName)
    local bossModelName = tabs.boss.Data.BossByDisplayName[displayName]
    if bossModelName then
        for modelName in pairs(tabs.boss.Data.SelectedBosses) do
            tabs.boss.Data.SelectedBosses[modelName] = false
        end
        tabs.boss.Data.SelectedBosses[bossModelName] = true
        selectedBossesLabel:SetText("Targeted Bosses: " .. displayName)
    end
end)

tabs.boss.addBossChoice = function(modelName, displayName)
    modelName = tostring(modelName or "")
    displayName = tostring(displayName or modelName)
    if modelName == "" or tabs.boss.Data.BossByDisplayName[displayName] then return end
    tabs.boss.Data.BossByDisplayName[displayName] = modelName
    if tabs.boss.Data.SelectedBosses[modelName] == nil then
        tabs.boss.Data.SelectedBosses[modelName] = false
    end
    table.insert(tabs.boss.Data.BossOrder, modelName)
    tabs.boss.BossDropdown:Add(displayName)
end

-- Cargar rarities con timeout y verificación
task.spawn(function()
    local shared = services.ReplicatedStorage:FindFirstChild("shared")
    if not shared then shared = services.ReplicatedStorage:WaitForChild("shared", 10) end
    local config = shared and shared:FindFirstChild("config")
    if not config then config = shared and shared:WaitForChild("config", 5) end
    local bossConfig = config and config:FindFirstChild("BossEventConfig")
    if not bossConfig then
        selectedBossesLabel:SetText("Farmed Bosses: Waiting for detection")
        return
    end
    local ok, mod = pcall(require, bossConfig)
    if not ok or type(mod) ~= "table" or not mod.RARITIES then
        selectedBossesLabel:SetText("Farmed Bosses: Waiting for detection")
        return
    end
    local allowedBossTiers = { "common", "rare", "epic", "legendary", "mythic", "rainbow" }
    for _, rarity in ipairs(mod.RARITIES) do
        local tierText = string.lower(tostring(rarity.Name or rarity.DisplayName or rarity.BossModel or ""))
        local modelText = string.lower(tostring(rarity.BossModel or ""))
        local allowed = false
        for _, tier in ipairs(allowedBossTiers) do
            if string.find(tierText, tier, 1, true) or string.find(modelText, tier, 1, true) then
                allowed = true
                break
            end
        end
        if allowed and rarity.BossModel then
            tabs.boss.addBossChoice(rarity.BossModel, rarity.DisplayName or rarity.Name or rarity.BossModel)
        end
    end
    if #tabs.boss.Data.BossOrder > 0 then
        selectedBossesLabel:SetText("Targeted Bosses: None (elegí uno)")
    else
        selectedBossesLabel:SetText("Farmed Bosses: Waiting for detection")
    end
end)

-- Special World Bosses
tabs.boss:AddSection("Special World Bosses")
local specialBossesLabel = tabs.boss:AddLabel("World bosses: All")

local specialBossDropdown = tabs.boss:AddDropdown("World boss target (select one)", function(displayName)
    local bossName = tabs.boss.Data.SpecialBossByDisplayName[displayName]
    if bossName then
        for _, name in ipairs(tabs.boss.Data.SpecialBossOrder) do
            tabs.boss.Data.SpecialBosses[name] = false
        end
        tabs.boss.Data.SpecialBosses[bossName] = true
        specialBossesLabel:SetText("World boss target: " .. bossName)
    end
end)

for _, bossName in ipairs(tabs.boss.Data.SpecialBossOrder) do
    tabs.boss.Data.SpecialBossByDisplayName[bossName] = bossName
    tabs.boss.Data.SpecialBosses[bossName] = false
    specialBossDropdown:Add(bossName)
end

-- Evade
tabs.boss.evadeAttack = function(model, hitbox, root, humanoid)
    local sequence = model:GetAttribute("BossAttackSequence")
    local attackKind = model:GetAttribute("BossAttackKind")
    local attackCFrame = model:GetAttribute("BossAttackCFrame")
    local impactTime = model:GetAttribute("BossAttackImpactTime")

    if typeof(sequence) == "number" and sequence ~= tabs.boss.Data.AttackSequence then
        tabs.boss.Data.AttackSequence = sequence
        if typeof(attackKind) == "string" and typeof(attackCFrame) == "CFrame"
            and typeof(impactTime) == "number" then
            tabs.boss.Data.EvadeUntil = impactTime + 0.6
        end
    end

    if typeof(attackCFrame) ~= "CFrame"
        or workspace:GetServerTimeNow() > tabs.boss.Data.EvadeUntil then
        return
    end

    attackKind = string.lower(tostring(attackKind or ""))

    if string.find(attackKind, "punch", 1, true) then
        local center = tabs.boss.getBossHeadPosition(model, hitbox)
        local direction = Vector3.new(attackCFrame.LookVector.X, 0, attackCFrame.LookVector.Z)
        if direction.Magnitude < 1 then
            direction = Vector3.new(hitbox.CFrame.LookVector.X, 0, hitbox.CFrame.LookVector.Z)
        end
        if direction.Magnitude < 1 then direction = Vector3.new(0, 0, 1) end
        local safePosition = center - direction.Unit * tabs.boss.Data.PunchBehindDistance
        root.CFrame = CFrame.lookAt(safePosition, center)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        bossStatusLabel:SetText("Status: Dodging Punch")
        return "Punch"
    end

    if not string.find(attackKind, "stomp", 1, true) then return end
    if humanoid.Health / math.max(humanoid.MaxHealth, 1) <= tabs.boss.Data.StompHealthThreshold then
        tabs.boss.Data.DodgeStomps = true
    end
    if not tabs.boss.Data.DodgeStomps then return end

    local direction = Vector3.new(root.Position.X - attackCFrame.Position.X, 0, root.Position.Z - attackCFrame.Position.Z)
    if direction.Magnitude < 1 then
        direction = Vector3.new(-attackCFrame.LookVector.X, 0, -attackCFrame.LookVector.Z)
    end
    if direction.Magnitude < 1 then direction = Vector3.new(1, 0, 0) end
    direction = direction.Unit
    local safePosition = attackCFrame.Position + direction * tabs.boss.Data.EvadeDistance + Vector3.new(0, 18, 0)
    root.CFrame = CFrame.lookAt(safePosition, attackCFrame.Position)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    bossStatusLabel:SetText("Status: Dodging Stomp")
    return "Stomp"
end

tabs.boss.getAliveCharacter = function(generation, timeout)
    local startedAt = os.clock()
    repeat
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if root and humanoid and humanoid.Health > 0 then
            utils.playerData.Character = character
            utils.playerData.Humanoid = humanoid
            return character, root, humanoid
        end
        bossStatusLabel:SetText("Status: Waiting for Respawn")
        task.wait(0.1)
    until not tabs.boss.Data.Running
        or tabs.boss.Data.Generation ~= generation
        or (timeout and os.clock() - startedAt >= timeout)
end

tabs.boss.findChest = function()
    local chest
    for _, candidate in ipairs(services.CollectionService:GetTagged("BossEventChest")) do
        if candidate:IsDescendantOf(workspace) then
            chest = candidate
            break
        end
    end
    if not chest then chest = workspace:FindFirstChild("BossChest", true) end
    if not chest then
        for _, candidate in ipairs(workspace:GetDescendants()) do
            if candidate:IsA("ProximityPrompt") and candidate.Name == "bossChestPrompt" then
                chest = candidate.Parent
                break
            end
        end
    end
    if not chest then return end
    local prompt = chest:FindFirstChild("bossChestPrompt", true)
    local part = prompt and prompt.Parent
        or (chest:IsA("Model") and (chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart", true)))
        or chest
    if part and part:IsA("BasePart") then
        return chest, prompt, part
    end
end

tabs.boss.collectChest = function(generation)
    bossStatusLabel:SetText("Status: Waiting for Chest")
    local startedAt = os.clock()
    local chest, prompt, part
    repeat
        chest, prompt, part = tabs.boss.findChest()
        if chest and chest:GetAttribute("BossChestEmerging") ~= true then break end
        task.wait(0.1)
    until not tabs.boss.Data.Running
        or tabs.boss.Data.Generation ~= generation
        or os.clock() - startedAt >= 12
    if not chest or not part then return end

    bossStatusLabel:SetText("Status: Collecting Chest")
    startedAt = os.clock()
    repeat
        local character, root = tabs.boss.getAliveCharacter(generation, 2)
        if character and root and chest.Parent and part.Parent then
            pcall(function()
                root.CFrame = CFrame.lookAt(part.Position + Vector3.new(0, 3, 4), part.Position)
                root.AssemblyLinearVelocity = Vector3.zero
            end)
            task.wait(0.15)
            if prompt and prompt.Parent and fireproximityprompt then
                pcall(function() fireproximityprompt(prompt) end)
            else
                pcall(function()
                    services.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.1)
                    services.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end)
            end
        end
        task.wait(0.25)
    until not tabs.boss.Data.Running
        or tabs.boss.Data.Generation ~= generation
        or player:GetAttribute("BossChestPending") == false
        or not chest.Parent
        or os.clock() - startedAt >= 12
end

tabs.boss.shouldFarmBoss = function(model, mode)
    if not model then return false end
    local isSpecial = tabs.boss.Data.SpecialBosses
        and tabs.boss.Data.SpecialBosses[model.Name] ~= nil
    if mode == "Halloween" then
        return isSpecial and tabs.boss.Data.SpecialBosses[model.Name] == true
    end
    if isSpecial then return false end
    return tabs.boss.Data.SelectedBosses[model.Name] == true
end

tabs.boss.findActiveBoss = function(mode)
    mode = mode or "Main"

    local function isAliveBoss(model, hitbox)
        if not model or not model:IsA("Model") then return false end
        if not hitbox or not hitbox:IsA("BasePart") then return false end
        if not model:IsDescendantOf(workspace) then return false end
        local stats = model:FindFirstChild("stats") or model:FindFirstChild("Stats")
        local health = stats and (stats:FindFirstChild("Health") or stats:FindFirstChild("health"))
        local maxHealth = stats and (stats:FindFirstChild("MaxHealth") or stats:FindFirstChild("maxHealth"))
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        local healthValue = health and tonumber(health.Value)
        if healthValue == nil and humanoid then healthValue = humanoid.Health end
        if healthValue == nil then healthValue = tonumber(model:GetAttribute("Health")) end
        if healthValue ~= nil and healthValue <= 0 then return false end
        return true, stats, health, maxHealth
    end

    if mode == "Halloween" then
        for _, bossName in ipairs(tabs.boss.Data.SpecialBossOrder) do
            if tabs.boss.Data.SpecialBosses[bossName] == true then
                for _, descendant in ipairs(workspace:GetDescendants()) do
                    if descendant:IsA("Model") and descendant.Name == bossName then
                        local hitbox = descendant:FindFirstChild("BossDamageHitbox", true)
                        local alive, stats, health, maxHealth = isAliveBoss(descendant, hitbox)
                        if alive then return descendant, hitbox, health, maxHealth end
                    end
                end
            end
        end
        return nil
    end

    for _, taggedBoss in ipairs(services.CollectionService:GetTagged("BossEventBoss")) do
        if taggedBoss:IsA("Model") and taggedBoss:IsDescendantOf(workspace)
            and tabs.boss.shouldFarmBoss(taggedBoss, mode) then
            local hitbox = taggedBoss:FindFirstChild("BossDamageHitbox", true)
            local alive, stats, health, maxHealth = isAliveBoss(taggedBoss, hitbox)
            if alive then return taggedBoss, hitbox, health, maxHealth end
        end
    end

    local events = workspace:FindFirstChild("Events")
    local bossFolder = events and (events:FindFirstChild("BossEvent") or events:FindFirstChild("BossArena"))
    if bossFolder then
        for _, descendant in ipairs(bossFolder:GetDescendants()) do
            if descendant:IsA("Model") and tabs.boss.shouldFarmBoss(descendant, mode) then
                local hitbox = descendant:FindFirstChild("BossDamageHitbox", true)
                local alive, stats, health, maxHealth = isAliveBoss(descendant, hitbox)
                if alive then return descendant, hitbox, health, maxHealth end
            end
        end
    end

    return nil
end

tabs.boss.attack = function(model, health, maxHealth, hitbox)
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end

    local evadeMode = tabs.boss.evadeAttack(model, hitbox, root, humanoid)
    if evadeMode == "Stomp" then return end

    local punch = character:FindFirstChild("Punch") or player.Backpack:FindFirstChild("Punch")
    if punch and punch.Parent ~= character then
        pcall(function() humanoid:EquipTool(punch) end)
    end

    local leftHand = character:FindFirstChild("LeftHand")
    local rightHand = character:FindFirstChild("RightHand")
    local center = hitbox.Position

    if evadeMode ~= "Punch" then
        local towardPlayer = root.Position - center
        towardPlayer = Vector3.new(towardPlayer.X, 0, towardPlayer.Z)
        if towardPlayer.Magnitude < 1 then
            towardPlayer = Vector3.new(hitbox.CFrame.LookVector.X, 0, hitbox.CFrame.LookVector.Z)
        end
        if towardPlayer.Magnitude < 1 then towardPlayer = Vector3.new(0, 0, 1) end
        local standPos = center + towardPlayer.Unit
            * math.max(3, math.min(6, hitbox.Size.Magnitude * 0.2)) + Vector3.new(0, 1.5, 0)
        root.CFrame = CFrame.lookAt(standPos, center)
    end

    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    utils.safeFireTouch(hitbox, leftHand)
    utils.safeFireTouch(hitbox, rightHand)

    if os.clock() - tabs.boss.Data.LastPunch >= tabs.boss.Data.PunchInterval then
        tabs.boss.Data.LastPunch = os.clock()
        pcall(function()
            player.muscleEvent:FireServer("punch", "leftHand")
            player.muscleEvent:FireServer("punch", "rightHand")
            if punch then punch:Activate() end
        end)
    end

    bossLabel:SetText("Boss: " .. (workspace:GetAttribute("BossDisplayName") or model.Name))
    bossHealthLabel:SetText("Health: " .. utils.formatNumber(tabs.boss.getBossHealth(health))
        .. " / " .. utils.formatNumber(tabs.boss.getBossMaxHealth(maxHealth)))
end

-- Pause / Resume training
tabs.boss.pauseTraining = function()
    if tabs.boss.Data.TrainingSnapshot then return end
    if not tabs.farming then return end
    tabs.boss.Data.TrainingSnapshot = {
        Rebirth = tabs.farming.RebirthData.IsAutoRebirthing,
        Size = tabs.farming.SizeData.Active,
        King = tabs.farming.KingData.TeleportActive,
        Tool = tabs.farming.ExerciseData.AutoFarm,
        Squat = tabs.farming.MachineExerciseData.Squat.Running,
        Lift = tabs.farming.MachineExerciseData.Lift.Running,
        AutoRep = tabs.farming.AutoRepRunning,
        Rock = _G.RockFarmRunning == true,
        Configs = {},
    }
    for _, config in ipairs(tabs.farming.Configs) do
        tabs.boss.Data.TrainingSnapshot.Configs[config.name] = tabs.farming.ActiveConfigs[config.name] == true
        if tabs.farming.ActiveConfigs[config.name] and config.Switch then
            config.Switch:Set(false, true)
        end
    end
    if tabs.boss.Data.TrainingSnapshot.Rebirth and tabs.farming.RebirthData.Switch then
        tabs.farming.RebirthData.Switch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.Size and tabs.farming.SizeSwitch then
        tabs.farming.SizeSwitch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.King and tabs.farming.KingSwitch then
        tabs.farming.KingSwitch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.Tool and tabs.farming.ToolExerciseSwitch then
        tabs.farming.ToolExerciseSwitch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.Squat and tabs.farming.SquatExerciseSwitch then
        tabs.farming.SquatExerciseSwitch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.Lift and tabs.farming.LiftExerciseSwitch then
        tabs.farming.LiftExerciseSwitch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.Squat or tabs.boss.Data.TrainingSnapshot.Lift then
        tabs.farming.leaveExerciseMachine()
    end
    if tabs.boss.Data.TrainingSnapshot.AutoRep and tabs.farming.AutoRepSwitch then
        tabs.farming.AutoRepSwitch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.Rock and tabs.farming.RockSwitch then
        tabs.farming.RockSwitch:Set(false, true)
    end
end

tabs.boss.resumeTraining = function()
    local snapshot = tabs.boss.Data.TrainingSnapshot
    if not snapshot then return end
    tabs.boss.Data.TrainingSnapshot = nil
    if snapshot.Rebirth and tabs.farming.RebirthData.Switch then
        tabs.farming.RebirthData.Switch:Set(false, true)
    end
    if snapshot.Size and tabs.farming.SizeSwitch then
        tabs.farming.SizeSwitch:Set(false, true)
    end
    if snapshot.King and tabs.farming.KingSwitch then
        tabs.farming.KingSwitch:Set(false, true)
    end
    if snapshot.Tool and tabs.farming.ToolExerciseSwitch then
        tabs.farming.ToolExerciseSwitch:Set(false, true)
    end
    if snapshot.Squat and tabs.farming.SquatExerciseSwitch then
        tabs.farming.SquatExerciseSwitch:Set(false, true)
    end
    if snapshot.Lift and tabs.farming.LiftExerciseSwitch then
        tabs.farming.LiftExerciseSwitch:Set(false, true)
    end
    if snapshot.AutoRep and tabs.farming.AutoRepSwitch then
        tabs.farming.AutoRepSwitch:Set(false, true)
    end
    if snapshot.Rock and tabs.farming.RockSwitch then
        tabs.farming.RockSwitch:Set(false, true)
    end
    for _, config in ipairs(tabs.farming.Configs) do
        if snapshot.Configs[config.name] and config.Switch then
            config.Switch:Set(false, true)
        end
    end
end

tabs.boss.startAutoFarmFull = function(mode, state)
    if not state then
        if tabs.boss.Data.ActiveMode == mode then
            tabs.boss.Data.Running = false
            tabs.boss.Data.ActiveMode = nil
            tabs.boss.Data.Generation += 1
            tabs.boss.Data.Phase = "Waiting"
            bossStatusLabel:SetText("Status: Disabled")
            if tabs.boss.resumeTraining then tabs.boss.resumeTraining() end
        end
        return
    end

    if mode == "Halloween" and tabs.boss.MainSwitch then
        tabs.boss.MainSwitch:Set(false, true)
    elseif mode == "Main" and tabs.boss.HalloweenSwitch then
        tabs.boss.HalloweenSwitch:Set(false, true)
    end

    tabs.boss.Data.ActiveMode = mode
    tabs.boss.Data.Running = true
    tabs.boss.Data.Generation += 1
    local generation = tabs.boss.Data.Generation

    task.spawn(function()
        local wasFighting = false
        while utils.isCurrent() and tabs.boss.Data.Running
            and tabs.boss.Data.Generation == generation
            and tabs.boss.Data.ActiveMode == mode do
            local model, hitbox, health, maxHealth, selected
            pcall(function()
                model, hitbox, health, maxHealth = tabs.boss.findActiveBoss(mode)
                selected = model and tabs.boss.shouldFarmBoss(model, mode)
            end)
            if model and not selected then
                if wasFighting then
                    wasFighting = false
                    if tabs.boss.resumeTraining then tabs.boss.resumeTraining() end
                end
                bossStatusLabel:SetText("Status: Skipping " .. model.Name)
            elseif model then
                if not wasFighting then
                    wasFighting = true
                    tabs.boss.Data.AttackSequence = nil
                    tabs.boss.Data.EvadeUntil = 0
                    tabs.boss.Data.DodgeStomps = false
                    if tabs.boss.pauseTraining then tabs.boss.pauseTraining() end
                end
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    bossStatusLabel:SetText("Status: Fighting "
                        .. (mode == "Halloween" and "Halloween Boss" or "Main Boss"))
                    tabs.boss.attack(model, health, maxHealth, hitbox)
                else
                    bossStatusLabel:SetText("Status: Waiting for Respawn")
                end
            elseif wasFighting then
                wasFighting = false
                pcall(tabs.boss.collectChest, generation)
                bossLabel:SetText("Boss: None")
                bossHealthLabel:SetText("Health: 0 / 0")
                if tabs.boss.Data.ContinueTraining and tabs.boss.resumeTraining then
                    tabs.boss.resumeTraining()
                end
                bossStatusLabel:SetText("Status: Waiting for Boss")
            else
                bossStatusLabel:SetText("Status: Waiting for "
                    .. (mode == "Halloween" and "Halloween Boss" or "Main-Island Boss"))
            end
            task.wait(model and selected and 0.03 or 0.25)
        end
    end)
end

tabs.boss.MainSwitch = tabs.boss:AddSwitch("Auto Boss — Main Island", function(state)
    tabs.boss.startAutoFarmFull("Main", state)
end)
tabs.boss.MainSwitch:Set(false)

tabs.boss.HalloweenSwitch = tabs.boss:AddSwitch("Auto Boss — Halloween", function(state)
    tabs.boss.startAutoFarmFull("Halloween", state)
end)
tabs.boss.HalloweenSwitch:Set(false)

tabs.boss:AddSwitch("Continue Training after Boss", function(state)
    tabs.boss.Data.ContinueTraining = state
end)

-- Info del siguiente boss
task.spawn(function()
    while utils.isCurrent() do
        if not tabs.boss.Data.Running then
            local nextTime = workspace:GetAttribute("BossSpawnNextTime")
            if typeof(nextTime) == "number" then
                local seconds = math.max(0, nextTime - workspace:GetServerTimeNow())
                local h = math.floor(seconds / 3600)
                local m = math.floor((seconds % 3600) / 60)
                local s = math.floor(seconds % 60)
                nextBossLabel:SetText(string.format("Next Boss: %dh %dm %ds", h, m, s))
            else
                nextBossLabel:SetText("Next Boss: N/A")
            end
        end
        task.wait(1)
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB PETS
-- ═══════════════════════════════════════════════════════════════
tabs.inventory:AddSection("Pet Shop")

tabs.inventory.PetShopRuntime = services.ReplicatedStorage:WaitForChild("shared", 15)
    and services.ReplicatedStorage.shared:WaitForChild("runtime", 10)
tabs.inventory.PetShopFolder = tabs.inventory.PetShopRuntime
    and tabs.inventory.PetShopRuntime:WaitForChild("cPetShopFolder", 10)
tabs.inventory.PetShopRemote = services.ReplicatedStorage:WaitForChild("rEvents", 10)
    and services.ReplicatedStorage.rEvents:WaitForChild("cPetShopRemote", 10)

tabs.inventory.PetShopData = {
    PetList = {},
    Selected = {},
    SelectedList = {},
    BuyAmount = 1,
}

tabs.inventory.AuraData = {
    AuraList = {},
    Selected = {},
    SelectedList = {},
    BuyAmount = 1,
}

if tabs.inventory.PetShopFolder then
    for _, item in ipairs(tabs.inventory.PetShopFolder:GetChildren()) do
        if item:GetAttribute("IsPowerUp") == true then
            table.insert(tabs.inventory.AuraData.AuraList, item.Name)
        else
            table.insert(tabs.inventory.PetShopData.PetList, item.Name)
        end
    end
    table.sort(tabs.inventory.PetShopData.PetList)
    table.sort(tabs.inventory.AuraData.AuraList)
end

local buyPetLabel = tabs.inventory:AddLabel("Selected Pets: None")

local petShopDropdown = tabs.inventory:AddDropdown("Choose Pet", function(text)
    if not tabs.inventory.PetShopData.Selected[text] then
        tabs.inventory.PetShopData.Selected[text] = true
        table.insert(tabs.inventory.PetShopData.SelectedList, text)
    end
    buyPetLabel:SetText("Selected Pets: "
        .. (#tabs.inventory.PetShopData.SelectedList > 0
            and table.concat(tabs.inventory.PetShopData.SelectedList, ", ") or "None"))
end)
for _, petName in ipairs(tabs.inventory.PetShopData.PetList) do
    petShopDropdown:Add(petName)
end

tabs.inventory:AddTextBox("Buy Amount:", function(text)
    tabs.inventory.PetShopData.BuyAmount = math.max(1, math.floor(tonumber(text) or 1))
end, { clear = false })

tabs.inventory:AddSwitch("Auto Buy Pet", function(bool)
    _G.AutoHatchPet = bool
    if not bool then return end
    task.spawn(function()
        while utils.isCurrent() and _G.AutoHatchPet do
            for _, petName in ipairs(tabs.inventory.PetShopData.SelectedList) do
                local selectedPet = tabs.inventory.PetShopFolder
                    and tabs.inventory.PetShopFolder:FindFirstChild(petName)
                if selectedPet and tabs.inventory.PetShopRemote then
                    for _ = 1, tabs.inventory.PetShopData.BuyAmount do
                        pcall(function()
                            tabs.inventory.PetShopRemote:InvokeServer(selectedPet)
                        end)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

tabs.inventory:AddButton("Clear Selected Pets", function()
    tabs.inventory.PetShopData.Selected = {}
    tabs.inventory.PetShopData.SelectedList = {}
    buyPetLabel:SetText("Selected Pets: None")
end)

-- Auras
tabs.inventory:AddSection("Auras")

local buyAuraLabel = tabs.inventory:AddLabel("Selected Auras: None")

local auraDropdown = tabs.inventory:AddDropdown("Choose Aura", function(text)
    if not tabs.inventory.AuraData.Selected[text] then
        tabs.inventory.AuraData.Selected[text] = true
        table.insert(tabs.inventory.AuraData.SelectedList, text)
    end
    buyAuraLabel:SetText("Selected Auras: "
        .. (#tabs.inventory.AuraData.SelectedList > 0
            and table.concat(tabs.inventory.AuraData.SelectedList, ", ") or "None"))
end)
for _, auraName in ipairs(tabs.inventory.AuraData.AuraList) do
    auraDropdown:Add(auraName)
end

tabs.inventory:AddTextBox("Buy Amount:", function(text)
    tabs.inventory.AuraData.BuyAmount = math.max(1, math.floor(tonumber(text) or 1))
end, { clear = false })

tabs.inventory:AddSwitch("Auto Buy Aura", function(bool)
    _G.AutoHatchAura = bool
    if not bool then return end
    task.spawn(function()
        while utils.isCurrent() and _G.AutoHatchAura do
            for _, auraName in ipairs(tabs.inventory.AuraData.SelectedList) do
                local selectedAura = tabs.inventory.PetShopFolder
                    and tabs.inventory.PetShopFolder:FindFirstChild(auraName)
                if selectedAura and tabs.inventory.PetShopRemote then
                    for _ = 1, tabs.inventory.AuraData.BuyAmount do
                        pcall(function()
                            tabs.inventory.PetShopRemote:InvokeServer(selectedAura)
                        end)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

-- Auto Pet
tabs.inventory:AddSection("Auto Pet")

tabs.inventory.AutoPetData = { Running = false, SelectedPet = nil }
local autoPetStatus = tabs.inventory:AddLabel("Status: Inactive")

local autoPetDropdown = tabs.inventory:AddDropdown("Choose Pet", function(text)
    tabs.inventory.AutoPetData.SelectedPet = text
end)
for _, petName in ipairs(tabs.inventory.PetShopData.PetList) do
    autoPetDropdown:Add(petName)
end

tabs.inventory:AddSwitch("Auto Pet", function(state)
    tabs.inventory.AutoPetData.Running = state
    if not state then
        autoPetStatus:SetText("Status: Inactive")
        return
    end
    if not tabs.inventory.AutoPetData.SelectedPet then
        utils.notify("Auto Pet", "Elegí un pet primero", 2, "warning")
        tabs.inventory.AutoPetData.Running = false
        return
    end
    autoPetStatus:SetText("Status: Comprando " .. tabs.inventory.AutoPetData.SelectedPet)
    task.spawn(function()
        while utils.isCurrent() and tabs.inventory.AutoPetData.Running do
            local petName = tabs.inventory.AutoPetData.SelectedPet
            local selectedPet = tabs.inventory.PetShopFolder
                and tabs.inventory.PetShopFolder:FindFirstChild(petName)
            if selectedPet and tabs.inventory.PetShopRemote then
                pcall(function()
                    tabs.inventory.PetShopRemote:InvokeServer(selectedPet)
                end)
            end
            task.wait(0.2)
        end
        autoPetStatus:SetText("Status: Inactive")
    end)
end)

-- Auto Evolve
tabs.inventory:AddSection("Auto Evolve")

tabs.inventory.EvolveData = { Selected = {}, SelectedList = {}, Amount = 1 }
local evolveLabel = tabs.inventory:AddLabel("Selected Pets: None")

local evolveDropdown = tabs.inventory:AddDropdown("Choose Pet", function(text)
    if not tabs.inventory.EvolveData.Selected[text] then
        tabs.inventory.EvolveData.Selected[text] = true
        table.insert(tabs.inventory.EvolveData.SelectedList, text)
    end
    evolveLabel:SetText("Selected Pets: "
        .. (#tabs.inventory.EvolveData.SelectedList > 0
            and table.concat(tabs.inventory.EvolveData.SelectedList, ", ") or "None"))
end)
for _, petName in ipairs(tabs.inventory.PetShopData.PetList) do
    evolveDropdown:Add(petName)
end

tabs.inventory:AddTextBox("Evolve Amount:", function(text)
    tabs.inventory.EvolveData.Amount = math.max(1, math.floor(tonumber(text) or 1))
end, { clear = false })

tabs.inventory.AutoEvolveRunning = false
tabs.inventory:AddSwitch("Auto Evolve", function(state)
    tabs.inventory.AutoEvolveRunning = state
    if not state then return end
    task.spawn(function()
        while utils.isCurrent() and tabs.inventory.AutoEvolveRunning do
            for _, petName in ipairs(tabs.inventory.EvolveData.SelectedList) do
                for _ = 1, tabs.inventory.EvolveData.Amount do
                    pcall(function()
                        services.ReplicatedStorage.rEvents.petEvolveEvent:FireServer("evolvePet", petName)
                    end)
                end
            end
            task.wait(0.5)
        end
    end)
end)

-- Auto Trade
tabs.inventory:AddSection("Auto Trade")

tabs.inventory.TradeData = {
    SelectedPlayers = {},
    SelectedPlayerList = {},
    SelectedPets = {},
    SelectedPetList = {},
    Generation = 0,
}

local tradePlayerLabel = tabs.inventory:AddLabel("Selected Players: None")
local tradePetLabel = tabs.inventory:AddLabel("Selected Pets: None")

local tradePlayerDropdown = tabs.inventory:AddDropdown("Choose Player", function(name)
    local username = name:match("| (.+)$") or name
    if not tabs.inventory.TradeData.SelectedPlayers[username] then
        tabs.inventory.TradeData.SelectedPlayers[username] = true
        table.insert(tabs.inventory.TradeData.SelectedPlayerList, username)
    end
    tradePlayerLabel:SetText("Selected Players: "
        .. (#tabs.inventory.TradeData.SelectedPlayerList > 0
            and table.concat(tabs.inventory.TradeData.SelectedPlayerList, ", ") or "None"))
end)

for _, p in ipairs(services.Players:GetPlayers()) do
    if p ~= player then
        tradePlayerDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end

local tradePetDropdown = tabs.inventory:AddDropdown("Choose Pet", function(text)
    if not tabs.inventory.TradeData.SelectedPets[text] then
        tabs.inventory.TradeData.SelectedPets[text] = true
        table.insert(tabs.inventory.TradeData.SelectedPetList, text)
    end
    tradePetLabel:SetText("Selected Pets: "
        .. (#tabs.inventory.TradeData.SelectedPetList > 0
            and table.concat(tabs.inventory.TradeData.SelectedPetList, ", ") or "None"))
end)
for _, petName in ipairs(tabs.inventory.PetShopData.PetList) do
    tradePetDropdown:Add(petName)
end

utils.connect(services.Players.PlayerAdded, function(p)
    if p ~= player then
        tradePlayerDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end)

utils.connect(services.Players.PlayerRemoving, function(p)
    tradePlayerDropdown:Remove(p.DisplayName .. " | " .. p.Name)
    if tabs.inventory.TradeData.SelectedPlayers[p.Name] then
        tabs.inventory.TradeData.SelectedPlayers[p.Name] = nil
        for i, v in ipairs(tabs.inventory.TradeData.SelectedPlayerList) do
            if v == p.Name then table.remove(tabs.inventory.TradeData.SelectedPlayerList, i) break end
        end
        tradePlayerLabel:SetText("Selected Players: "
            .. (#tabs.inventory.TradeData.SelectedPlayerList > 0
                and table.concat(tabs.inventory.TradeData.SelectedPlayerList, ", ") or "None"))
    end
end)

tabs.inventory.AutoTradeRunning = false
tabs.inventory:AddSwitch("Auto Trade", function(state)
    tabs.inventory.AutoTradeRunning = state
    tabs.inventory.TradeData.Generation += 1
    if not state then return end
    local generation = tabs.inventory.TradeData.Generation

    task.spawn(function()
        while utils.isCurrent() and tabs.inventory.AutoTradeRunning
            and tabs.inventory.TradeData.Generation == generation do
            if #tabs.inventory.TradeData.SelectedPlayerList > 0
                and #tabs.inventory.TradeData.SelectedPetList > 0 then
                for _, username in ipairs(tabs.inventory.TradeData.SelectedPlayerList) do
                    local tradePlayer = services.Players:FindFirstChild(username)
                    if not tabs.inventory.AutoTradeRunning
                        or tabs.inventory.TradeData.Generation ~= generation then break end
                    if tradePlayer then
                        local tradingEvent = services.ReplicatedStorage.rEvents.tradingEvent
                        local unique = player.petsFolder and player.petsFolder:FindFirstChild("Unique")
                        if tradingEvent and unique then
                            pcall(function()
                                tradingEvent:FireServer("sendTradeRequest", tradePlayer)
                            end)
                            task.wait(0.5)
                            local offered = 0
                            local offeredPets = {}
                            for _, selectedName in ipairs(tabs.inventory.TradeData.SelectedPetList) do
                                for _, pet in ipairs(unique:GetChildren()) do
                                    if pet.Name == selectedName and not offeredPets[pet] and offered < 6 then
                                        pcall(function()
                                            tradingEvent:FireServer("offerItem", pet)
                                        end)
                                        offeredPets[pet] = true
                                        offered = offered + 1
                                        task.wait(0.05)
                                        break
                                    end
                                end
                            end
                            if offered > 0 then
                                task.wait(0.5)
                                pcall(function()
                                    tradingEvent:FireServer("acceptTrade")
                                end)
                                task.wait(2)
                            end
                        end
                    end
                end
            end
            task.wait(2)
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB BOOSTS
-- ═══════════════════════════════════════════════════════════════
tabs.boosts:AddSection("Boost Eater")

tabs.boosts.EggEaterData = { Running = false }

tabs.boosts:AddSwitch("Eat All Eggs", function(state)
    tabs.boosts.EggEaterData.Running = state
    if not state then return end
    task.spawn(function()
        while utils.isCurrent() and tabs.boosts.EggEaterData.Running do
            local char = player.Character
            local egg = char and char:FindFirstChild("Protein Egg")
                or player.Backpack:FindFirstChild("Protein Egg")
            if egg then
                pcall(function()
                    player.muscleEvent:FireServer("proteinEgg", egg)
                end)
            end
            task.wait(0.25)
        end
    end)
end):Set(false)

tabs.boosts.BoostData = {
    ItemList = {
        "Tropical Shake", "Energy Shake", "Protein Bar", "TOUGH Bar",
        "Protein Shake", "ULTRA Shake", "Energy Bar",
    },
    Running = false,
}

tabs.boosts:AddSwitch("Eat All Boosts (expect lag)", function(state)
    tabs.boosts.BoostData.Running = state
    if not state then return end
    task.spawn(function()
        while utils.isCurrent() and tabs.boosts.BoostData.Running do
            local char = player.Character
            for _, itemName in ipairs(tabs.boosts.BoostData.ItemList) do
                local tool = char and char:FindFirstChild(itemName)
                    or player.Backpack:FindFirstChild(itemName)
                if tool then
                    local parts = {}
                    for word in itemName:gmatch("%S+") do
                        table.insert(parts, word:lower())
                    end
                    for i = 2, #parts do
                        parts[i] = parts[i]:sub(1, 1):upper() .. parts[i]:sub(2)
                    end
                    for _ = 1, 10 do
                        pcall(function()
                            player.muscleEvent:FireServer(table.concat(parts), tool)
                        end)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

-- Contador de boosts
tabs.boosts:AddSection("Contador de Boosts")
local comboLabel = tabs.boosts:AddLabel("Combo: Sin boosts")

task.spawn(function()
    while utils.isCurrent() do
        local items = {
            ProteinEgg = 0, TropicalShake = 0, EnergyShake = 0, ProteinBar = 0,
            ToughBar = 0, ProteinShake = 0, UltraShake = 0, EnergyBar = 0,
        }
        local char = player.Character
        if char then
            for _, item in ipairs(char:GetChildren()) do
                if items[item.Name] ~= nil then items[item.Name] = items[item.Name] + 1 end
            end
        end
        for _, item in ipairs(player.Backpack:GetChildren()) do
            if items[item.Name] ~= nil then items[item.Name] = items[item.Name] + 1 end
        end
        local active = {}
        for name, count in pairs(items) do
            if count > 0 then table.insert(active, name .. " (" .. count .. ")") end
        end
        if #active == 0 then
            comboLabel:SetText("Combo: Sin boosts")
        else
            comboLabel:SetText("Combo: " .. table.concat(active, " · "))
        end
        task.wait(2)
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB TELEPORTS
-- ═══════════════════════════════════════════════════════════════
tabs.teleport:AddSection("Main")

tabs.teleport.Locations = {
    { name = "Tiny Island", pos = CFrame.new(-37.1, 9.2, 1919) },
    { name = "Main Island", pos = CFrame.new(16.07, 9.08, 133.8) },
    { name = "Beach",       pos = CFrame.new(-8, 9, -169.2) },
}

for _, loc in ipairs(tabs.teleport.Locations) do
    tabs.teleport:AddButton(loc.name, function()
        local char = player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = loc.pos
                utils.notify("Teleport", "Teletransportado a " .. loc.name, 1.5, "success")
            end
        end
    end)
end

tabs.teleport:AddSection("Gyms")

tabs.teleport.GymLocations = {
    { name = "Overcharged Gym",   pos = CFrame.new(-2941.766, 151.797, 4994.552) },
    { name = "Industrial Gym",    pos = CFrame.new(-5254.681641, 58.342850, 4931.850586) },
    { name = "Jungle Gym",        pos = CFrame.new(-8543, 6.8, 2400) },
    { name = "Muscle King Gym",   pos = CFrame.new(-8665.4, 17.21, -5792.9) },
    { name = "Legends Gym",       pos = CFrame.new(4516, 991.5, -3856) },
    { name = "Infernal Gym",      pos = CFrame.new(-6759, 7.36, -1284) },
    { name = "Mythical Gym",      pos = CFrame.new(2250, 7.37, 1073.2) },
    { name = "Frost Gym",         pos = CFrame.new(-2623, 7.36, -409) },
}

for _, gym in ipairs(tabs.teleport.GymLocations) do
    tabs.teleport:AddButton(gym.name, function()
        local char = player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = gym.pos
                utils.notify("Teleport", "Teletransportado a " .. gym.name, 1.5, "success")
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- TAB STATS
-- ═══════════════════════════════════════════════════════════════
tabs.stats:AddSection("Métricas en Tiempo Real")

tabs.stats.Data = {
    StartTime = tick(),
    StartStrength = leaderstats and leaderstats:WaitForChild("Strength", 10)
        and leaderstats.Strength.Value or 0,
    StartRebirths = leaderstats and leaderstats:WaitForChild("Rebirths", 10)
        and leaderstats.Rebirths.Value or 0,
}

local strengthGainedLabel = tabs.stats:AddLabel("Fuerza ganada: 0")
local strengthHourLabel = tabs.stats:AddLabel("x 1 Hora: 0")
local strengthDayLabel = tabs.stats:AddLabel("x 1 Día: 0")
local strengthWeekLabel = tabs.stats:AddLabel("x 1 Semana: 0")

tabs.stats:AddLabel("")

local rebirthsGainedLabel = tabs.stats:AddLabel("Rebirths ganados: 0")
local rebirthsHourLabel = tabs.stats:AddLabel("x 1 Hora: 0")
local rebirthsDayLabel = tabs.stats:AddLabel("x 1 Día: 0")
local rebirthsWeekLabel = tabs.stats:AddLabel("x 1 Semana: 0")

tabs.stats:AddLabel("")
local sessionTimeLabel = tabs.stats:AddLabel("Tiempo en sesión: 0s")

local function formatStat(n)
    if n == nil or n ~= n then return "0" end
    local absN = math.abs(n)
    local sign = n < 0 and "-" or ""
    if absN >= 1e18 then return sign .. string.format("%.2fqi", absN / 1e18)
    elseif absN >= 1e15 then return sign .. string.format("%.2fqa", absN / 1e15)
    elseif absN >= 1e12 then return sign .. string.format("%.2ft", absN / 1e12)
    elseif absN >= 1e9 then return sign .. string.format("%.2fb", absN / 1e9)
    elseif absN >= 1e6 then return sign .. string.format("%.2fm", absN / 1e6)
    elseif absN >= 1e3 then return sign .. string.format("%.2fk", absN / 1e3)
    elseif absN >= 1 then return sign .. string.format("%.0f", absN)
    else return sign .. string.format("%.2f", absN) end
end

local function formatTiempo(segundos)
    if segundos < 60 then return string.format("%ds", math.floor(segundos))
    elseif segundos < 3600 then return string.format("%dm %ds", math.floor(segundos / 60), math.floor(segundos % 60))
    elseif segundos < 86400 then return string.format("%dh %dm", math.floor(segundos / 3600), math.floor((segundos % 3600) / 60))
    else return string.format("%dd %dh", math.floor(segundos / 86400), math.floor((segundos % 86400) / 3600)) end
end

task.spawn(function()
    while utils.isCurrent() do
        local now = tick()
        local elapsed = now - tabs.stats.Data.StartTime
        if elapsed > 0.5 and leaderstats then
            local curStrength = leaderstats:FindFirstChild("Strength")
            local curRebirths = leaderstats:FindFirstChild("Rebirths")
            if curStrength and curRebirths then
                local gainS = curStrength.Value - tabs.stats.Data.StartStrength
                local gainR = curRebirths.Value - tabs.stats.Data.StartRebirths
                local rateS = (gainS / elapsed) * 3600
                local rateR = (gainR / elapsed) * 3600
                strengthGainedLabel:SetText("Fuerza ganada: " .. formatStat(gainS))
                strengthHourLabel:SetText("x 1 Hora: " .. formatStat(rateS))
                strengthDayLabel:SetText("x 1 Día: " .. formatStat(rateS * 24))
                strengthWeekLabel:SetText("x 1 Semana: " .. formatStat(rateS * 24 * 7))
                rebirthsGainedLabel:SetText("Rebirths ganados: " .. formatStat(gainR))
                rebirthsHourLabel:SetText("x 1 Hora: " .. formatStat(rateR))
                rebirthsDayLabel:SetText("x 1 Día: " .. formatStat(rateR * 24))
                rebirthsWeekLabel:SetText("x 1 Semana: " .. formatStat(rateR * 24 * 7))
                sessionTimeLabel:SetText("Tiempo en sesión: " .. formatTiempo(elapsed))
            end
        end
        task.wait(1)
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- ANTI-AFK INDEPENDIENTE
-- ═══════════════════════════════════════════════════════════════
tabs.main:AddSection("Anti-AFK")

_G.HonenxAntiAFK = true
tabs.main.AntiAFKSwitch = tabs.main:AddSwitch("Anti AFK", function(state)
    _G.HonenxAntiAFK = state
    if state then
        utils.notify("Anti-AFK", "✅ Activado", 2, "success")
    else
        utils.notify("Anti-AFK", "❌ Desactivado", 2, "info")
    end
end)
tabs.main.AntiAFKSwitch:Set(true)

task.spawn(function()
    while utils.isCurrent() do
        task.wait(60)
        if _G.HonenxAntiAFK then
            pcall(function()
                services.VirtualUser:CaptureController()
                services.VirtualUser:ClickButton2(Vector2.new(0, 0))
                services.VirtualUser:ClickButton1(Vector2.new(0, 0))
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- EMERGENCY STOP
-- ═══════════════════════════════════════════════════════════════
tabs.info:AddSection("Emergency")

tabs.info:AddButton("🛑 EMERGENCY STOP", function()
    if _G.HonenxWhiteUltraFastRep then _G.HonenxWhiteUltraFastRep.Enabled = false end
    if _G.RockFarmRunning then _G.RockFarmRunning = false end
    if _G.deathRingEnabled then _G.deathRingEnabled = false end
    if _G.killAll then _G.killAll = false end
    if _G.killBlacklistedOnly then _G.killBlacklistedOnly = false end
    if _G.HonenxAntiAFK then _G.HonenxAntiAFK = false end

    if tabs.fast then
        if tabs.fast.FastRepData then tabs.fast.FastRepData.Running = false end
        if tabs.fast.FastRebirthData then tabs.fast.FastRebirthData.Running = false end
        if tabs.fast.UltraData then tabs.fast.UltraData.Running = false end
        if tabs.fast.ChaosData then tabs.fast.ChaosData.Running = false end
    end

    if tabs.boss and tabs.boss.Data then
        tabs.boss.Data.Running = false
        tabs.boss.Data.ActiveMode = nil
    end

    if tabs.farming then
        if tabs.farming.MachineExerciseData then
            tabs.farming.MachineExerciseData.Squat.Running = false
            tabs.farming.MachineExerciseData.Lift.Running = false
        end
        if tabs.farming.ActiveConfigs then
            for name in pairs(tabs.farming.ActiveConfigs) do
                tabs.farming.ActiveConfigs[name] = false
            end
        end
    end

    utils.notify("Emergency Stop", "Todas las funciones detenidas", 4, "error")
end)

-- ═══════════════════════════════════════════════════════════════
-- CIERRE
-- ═══════════════════════════════════════════════════════════════
utils.notify("HonenxWhite", "🎉 Hub completo cargado correctamente", 4, "success")
print("[HonenxWhite] Script cargado al 100%")
print("[HonenxWhite] Tabs: Main, Killing, Specs, Farming, Fast, Boss, Pets, Boosts, Teleports, Stats, Info")
print("[HonenxWhite] Build: KNI UI v2.0 (corregido)")
