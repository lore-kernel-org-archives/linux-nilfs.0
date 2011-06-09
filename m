From: Andrea Gelmini <andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Problem setting CP interval
Date: Thu, 9 Jun 2011 16:11:24 +0200
Message-ID: <BANLkTimA3C9rCnsEHuCVwpx1DcB-a0757A@mail.gmail.com>
References: <BANLkTim7Dp7-U1ee1hm7EWpw5We+pPBjAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=002354530ec43f6c8604a54807d3
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:in-reply-to:references:date
         :message-id:subject:from:to:cc:content-type;
        bh=JnV6QYsLZgiF3nX19s+182HP9V08CztkNOESAt6C1Sc=;
        b=lMnb/LB0/ChhbW4kBAJJnCizXcqyd5xVI9QOq+QA07ut8D1AWkm/URrUtG6mkEtYHF
         lBmqLWlTs6boLE7Y7uJzVEF/S3QhhE8QdZHNPzmsLbo4tBvFkyyNm5cm5XoX/ZTGOSqX
         N8lhtBKexHpYL9D7x96PBOQ3DUfz32iaFOEAI=
In-Reply-To: <BANLkTim7Dp7-U1ee1hm7EWpw5We+pPBjAw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

--002354530ec43f6c8604a54807d3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2011/6/8 Andrea Gelmini <andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:

Hi all,
   and thanks a lot for your time.

> =C2=A0 But it doesn't care... I can change 'Commit interval' in any way,
> =C2=A0 but when I mount it I see this:
> [ 2366.096819] segctord starting. Construction interval =3D 0 seconds,
> CP frequency < 30 seconds
> [ 2535.082421] segctord starting. Construction interval =3D 0 seconds,
> CP frequency < 30 seconds

I made a stupid script to replicate my problem.
Results are the same, using different kernel, and so on.
I also tried different version of nilfs-tools, picking via git
since commit that introduce nilfs-tune.

You have just to run it as root (give it a look, before):
root@dell:/home/gelma/dev/prg# bash test_nilf.sh
0+0 records in
0+0 records out
0 bytes (0 B) copied, 3.506e-05 s, 0.0 kB/s
mkfs.nilfs2 (nilfs-utils 2.1.0-rc1)
Start writing file system initial data to the device
       Blocksize:4096  Device:/dev/loop0  Device Size:1073741824
File system initialization succeeded !!
[  623.103552] segctord starting. Construction interval =3D 5 seconds,
CP frequency < 30 seconds
nilfs-tune 2.1.0-rc1
[  624.212073] segctord starting. Construction interval =3D 0 seconds,
CP frequency < 30 seconds

Thanks a lot for your time,
Andrea

--002354530ec43f6c8604a54807d3
Content-Type: application/x-sh; name="test_nilf.sh"
Content-Disposition: attachment; filename="test_nilf.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gopsc4ie0

IyEvYmluL2Jhc2gKCmZpbGVfZm9yX2xvb3BiYWNrPScvdG1wL2xvb3AtZmlsZS10ZXN0Jwptb3Vu
dHBvaW50PScvdG1wL25pbGZzdGVzdCcKbWtkaXIgJG1vdW50cG9pbnQKCmRvLXRlc3QoKSB7Cglk
ZCBpZj0vZGV2L3plcm8gb2Y9JGZpbGVfZm9yX2xvb3BiYWNrIGJzPTFHIGNvdW50PTAgc2Vlaz0x
ICYmIFwKCSAgIGxvc2V0dXAgL2Rldi9sb29wMCAkZmlsZV9mb3JfbG9vcGJhY2sgJiYgXAoJICAg
bWtmcy5uaWxmczIgLWIgJDEgL2Rldi9sb29wMCAmJiBcCgkgICBtb3VudCAvZGV2L2xvb3AwICRt
b3VudHBvaW50ICYmIFwKCSAgIGRtZXNnIHwgdGFpbCAtbjEKCXVtb3VudCAkbW91bnRwb2ludAoJ
bmlsZnMtdHVuZSAtaSAyNSAvZGV2L2xvb3AwCgltb3VudCAvZGV2L2xvb3AwICRtb3VudHBvaW50
CglkbWVzZ3wgdGFpbCAtbjEKCXVtb3VudCAvZGV2L2xvb3AwCglsb3NldHVwIC1kIC9kZXYvbG9v
cDAKCXJtIC1mICRmaWxlX2Zvcl9sb29wYmFjawp9Cgpkby10ZXN0IDQwOTYK
--002354530ec43f6c8604a54807d3--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
