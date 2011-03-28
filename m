From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix data loss in mmap page write for hole blocks
Date: Mon, 28 Mar 2011 10:15:50 +0200
Message-ID: <201103281015.50533.dexen.devries@gmail.com>
References: <1301240873-12035-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=EFqCOHVD8V6dilh2hXDZO1RILYQHWhXvAVL2Bn3rJ+w=;
        b=L8VLQsriYQcR478PvhynArqfGAYrPjI/Uf04MtPxGijGKa8GVmWPiqlRXrM/s4dsPs
         nbKSOFB+2l+RWwkccG0D/deXrJqTsHNDNU0nKSbea4PzbqQQXSpusqiBz2q1ZxLLJT1s
         MwStcCygbvKjfF0Joq8d+L32gjk2k+O50Y/6o=
In-Reply-To: <1301240873-12035-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Sunday 27 of March 2011 17:47:53 Ryusuke wrote:
> From the result of a function test of mmap, mmap write to shared page=
s
> turned out to be broken for hole blocks.  It doesn't write out filled
> blocks and the data will be lost after umount.  This is due to a bug
> that the target file is not queued for log writer when filling hole
> blocks. (...)

recently I've experienced a few times data loss & hang of several appli=
cations=20
with ktorrent running. It seems the transfered files were mostly empty =
after=20
reboot. Related to this regression & fix?


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
