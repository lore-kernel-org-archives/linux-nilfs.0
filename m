From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount & fsck of nilfs partition fail. [correction]
Date: Tue, 14 Jun 2011 00:28:32 +0200
Message-ID: <201106140028.33124.dexen.devries@gmail.com>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E02D@COLOSSEXCH01.starsolutions.com> <053D39D3D76C474EB2D2A284AA6BA3181B05E4E167@COLOSSEXCH01.starsolutions.com> <201106140021.52229.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=Jl9sjZKrDVUSIbnLDXu+6OpbHF9s9nw78bZ0vjK2NhQ=;
        b=cWJj6SGcJbFOkxkCkI9FS6v9f+JubT+JkbSZSQ5cq0ubLbhd2dxE+P2IPGECbK50oS
         KYmOvn6pIwkLwvYtkjqxVXv3ZONOfwfHyXbbR/U383ocrSEcraFX2sFInqUBTZx9goYV
         0fiWhZEkUj/yzY9WeBTmcb+OFqKeFGQvgJejw=
In-Reply-To: <201106140021.52229.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi again Zahid,


On Tuesday 14 June 2011 00:21:51 I wrote:
> $ git co -b fsck0 remotes/origin/fsck0


important correction: make that last line read:
$ git checkout -b fsck0 remotes/origin/fsck0

(`co' is not a git command, `checkout' is)


Sorry for the screw-up,
-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
