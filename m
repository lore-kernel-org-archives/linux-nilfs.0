From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: how are files allocated on nilfs?
Date: Wed, 4 May 2011 18:02:16 +0200
Message-ID: <201105041802.17155.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=1Db3LnfCQLNvHczh+IOqUKwMvgA33zzZILkqGdXb7M4=;
        b=g/XbqzlOyTJ5MntbmOt+KpDe22XMNC+aTN6DOrD3NyxpZrJcSNwoOs1nnTEW6Mwxp5
         tcysO3JxcpM0iiHRphnqXegLQUgruBzQRSC9uMtVoNBbJyNUBEGlIatcGFPFpfjrORsN
         JaLpA5Nsn+b2p6zOLH3iw/Hz5jnFx5WmCf5kw=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

a possibly naive question: how are files allocated on nilfs?

Asking, because I've expected a large-ish (128MB) file to be mostly=20
continuous, modulo segment headers. But it doesn't seem so. A small tes=
t to=20
narrow down the question:
 0) created a new, empty, nilfs, on a separate partition (about 1GB siz=
e)
 1) created a file with dd if=3D/dev/zero of=3Da.bin bs=3D$((128*1024*1=
024)) count=3D1
 2) ran hdparm --fibmap a.bin
output:
 byte_offset  begin_LBA    end_LBA    sectors
         0        231      16446      16216
     8302592      16503      29094      12592
    14749696      29239      32830       3592
    16588800      32895      49214      16320
    24944640      49255      58158       8904
    29503488      58327      65598       7272
    33226752      65663      81982      16320
    41582592      82007      87230       5224
    44257280      87415      98366      10952
    49864704      98431     114750      16320
    58220544     114759     116302       1544
    59011072     116503     131134      14632
    66502656     131191     145374      14184
    73764864     145519     147518       2000
    74788864     147583     163902      16320
    83144704     163951     174446      10496
    88518656     174607     180286       5680
    91426816     180351     196670      16320
    99782656     196703     203518       6816
   103272448     203695     213054       9360
   108064768     213119     229438      16320
   116420608     229455     232590       3136
   118026240     232783     245822      13040
   124702720     245887     261662      15776


while the first chunk of file fills almost whole segment, several subse=
quent=20
chunks are much smaller than segment. Why is it so?


Regards,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

``In other news, STFU and hack.''
mahmud, in response to Erann Gat's ``How I lost my faith in Lisp''
http://news.ycombinator.com/item?id=3D2308816
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
