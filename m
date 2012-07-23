From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: read error on superblock
Date: Mon, 23 Jul 2012 13:06:57 +0200
Message-ID: <2948186.vfdzh15lNi@coil>
References: <19753282.RhzHOQAfKG@coil> <1343035048.1974.6.camel@slavad-ubuntu-11> <20120723.183907.154986664.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-face:user-agent:in-reply-to
         :references:mime-version:content-transfer-encoding:content-type;
        bh=H6FHpd1r1T1wQrBCrpqjOaGKFsGZAiLVv/uaSrR/7Q8=;
        b=Ozp52SMpFLwboZeGA4yzsIMJ+PUnHHhpcWuAZbnQM2tqnRdf8AAMKHBygD831f77kE
         oJl8AtYtXX7jkrY3uQAnhuRrdgK6ZGqe+KkEXYmUvZ9VRY84kvxCDM3SAUIzix2t6ecD
         Kjr2OWE3asa0utiCDmKv/Sk/8JblVunfRnmXzWdPqiFM+a4pmnS3rg6ymZwiLbXet0al
         iCgIhxy1gv0S1S0ZCucF8x6h2BQCYweIMJOM0Fb9pQkEIujBkMIgDyu+tIk/7ESMmYrV
         s98Z3g6KqlQ1JV11sQ5NEztMvICS7ZTIxwwTRjkkkzXZso+fPJE6ZXBWRdyzUb8gjtX4
         aGGw==
In-Reply-To: <20120723.183907.154986664.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi again,

On Monday 23 of July 2012 18:39:07 you wrote:
> Looks weird.  mount.nilfs2 doesn't output this error message.


another computer, same drive:

coil!root!/mnt # mount.nilfs2 -v /dev/sdc3 x -o errors=3Dcontinue,norec=
overy
mount.nilfs2: Error while mounting /dev/sdc3 on x: Input/output error


also, in dmesg:
> NILFS warning: mounting unchecked fs
> ((lotsa ATA read error stuff))
> NILFS: error searching super root.


--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

"all dichotomies are either true or false" is a true paradox because it=
's=20
paradoxical only if it is a paradox ;)
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
