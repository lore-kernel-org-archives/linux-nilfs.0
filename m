From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Tue, 8 Jan 2013 15:52:30 +0300
Message-ID: <504C0292-D0C6-426C-BDFD-1CD50FB32617@dubeyko.com>
References: <20121129210650.GA4028@wloczykij> <1354255744.2090.3.camel@slavad-ubuntu> <20121130073219.GB4028@wloczykij> <1356415552.2052.11.camel@slavad-ubuntu> <20130103214913.GE2080@wloczykij> <28ABE57F-66DD-491E-9FDB-A6CE3CF773FB@dubeyko.com> <20130104191633.GF2080@wloczykij> <C2F4A5DE-538B-4468-9A6A-BA619EDDA462@dubeyko.com> <20130105164752.GG2080@wloczykij>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=KmJAuxW0NbXs9mXlFUV+nk97/y0DhGJ8Rooi+Iyj/24=;
	b=DVq14eGJY/L7kkQbjC7136OcHVe9+x32Gc3eU4eMeHT1CqOTSbireNGk3RsESlcAVN0CpCsdDA5pOLYWhwDDFYO0V5Y88Vy/5QP+YUV63sqeMgfIbxOoh/H5V92zGzXE;
In-Reply-To: <20130105164752.GG2080@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>, Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?B?0KHQtdGA0LPQtdC5INCQ0LvQtdC60YHQsNC90LTRgNC+0LI=?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi guys,

I am trying to reproduce the issue last three days but without success.=
 I tried different workloads and different environments. As I know all =
of you have the issue in reproduced state. So I have additional questio=
ns.

1. All of you have such messages:

Jan 03 22:36:38 [kernel] [  953.289973] NILFS: bad btree node (blocknr=3D=
26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
Jan 03 22:36:38 [kernel] [  953.289976] NILFS error (device sda2): nilf=
s_bmap_lookup_contig: broken bmap (inode number=3D102230)

As I understand, you still have message for concrete block number (for =
example, blocknr=3D26229286) during remount. But you haven't the messag=
e for this block number (for example, blocknr=3D26229286) after umount =
and mount again. But you can get error messages for another block numbe=
r after it. Am I correct?

2. As I understand, you have corrupted file on your volume after such e=
rror message (for example, for inode number=3D102230).

=E5=9C=A8 2013-1-6=EF=BC=8C12:46=EF=BC=8CElmer Zhang <freeboy6716@gmail=
=2Ecom> =E5=86=99=E9=81=93=EF=BC=9A

> I have found the corrupted file using inode number:
> [root@yf237 data0]# cat mysql6003/app_wyxgrab/weibo_rank.MYI > /dev/n=
ull=20
> cat: mysql6003/app_wyxgrab/weibo_rank.MYI: Input/output error

Could you share strace output for "cat" command for such corrupted file=
? Maybe syslog can contain some interesting details during execution of=
 "cat" command. Could you check syslog for interesting error messages d=
uring such try?

3. Could you share configuration file of your kernel (.config)? I suspe=
ct that you can have some special configuration of your environment tha=
t I haven't.

4. Could you share content of nilfs_cleanerd.conf file for NILFS2 parti=
tion that has such issue? Sorry, if I ask about it again.

5. Did you have any sudden power-off before you encounter the issue fir=
stly?

6. I understand that it can be not so easy. But, anyway, could you shar=
e details of your system log for the case of first case of the issue oc=
currence? I need only details about how live system before the issue.

7. I analyzed the raw dump of segment that I received from Elmer Zhang.=
 Currently, I have such feeling that it takes place situation when driv=
er tries to take block that was filled by GC yet. But it needs to inves=
tigate the issue more deeply. And, currently, I don't understand how th=
e issue can be achieved. Successful reproducing of the issue is a half =
of the success.

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
