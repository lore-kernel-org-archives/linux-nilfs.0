From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: read error on superblock
Date: Mon, 23 Jul 2012 11:24:08 +0200
Message-ID: <1473809.3VOqpg65Ko@coil>
References: <19753282.RhzHOQAfKG@coil> <1343035048.1974.6.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-face:user-agent:in-reply-to
         :references:mime-version:content-transfer-encoding:content-type;
        bh=++iURTx1bdozrVOHca9MUYt0UNhpbzhDHJmg6h9Q7uE=;
        b=LaBY94OCIxNxn2dsSKa9iWv1xY9XwjNRPAdWRePUL+NLL+AzRPCF9mGjVZMJvO9k6Y
         S6c1i1dB9WEX7k5rPVp3q+TDyRJVQqU3A4AdcrSHnPACSb4M8EmxmAwGKu8CG6LMI6oJ
         25ptrM5XVwxO4RP++WqFnJH3L0SPCIgHzBASp0/EniB+LRZaxGeFAMyNUPtMCJ5XVng9
         gLuYAvkrbofu/6Gv3L5GEv5l49qAi3qPpk07PeF6ASfDIdmJ8jXYksXnkgPonB+VNIp/
         xEfgudDxLoG1GKDrNOWeBt/5fhYehf0aMCrQ9u/CFGwI9X51ZaBTFD2o2DhMcFiKomGP
         D2Ug==
In-Reply-To: <1343035048.1974.6.camel@slavad-ubuntu-11>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslaw,


On Monday 23 of July 2012 13:17:28 you wrote:
> It exits second superblock at the end of NILFS volume. But it can be =
not
> in fully synchronous state with primary ones (as I guess).
> Theoretically, it is possible to copy secondary superblock on the pla=
ce
> of primary. But I am afraid that the NILFS volume can be in inconsist=
ent
> state anyway.

any hints how to locate the superblock? what offset to look at, and wha=
t's the=20
magic number(s)?


> Do you sure that this volume doesn't contain another damaged sectors?


in my case, that doesn't matter: all the data i want to recover is eith=
er in=20
Git (which does internal consistency checks) or in MySQL, which also do=
es=20
/some/ consistency checks.


Cheers,
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
