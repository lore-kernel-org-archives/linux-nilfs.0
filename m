From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [correction] Re: Removed checkpoints are still subject to protection period
Date: Wed, 22 Jun 2011 13:04:53 +0200
Message-ID: <201106221304.53495.dexen.devries@gmail.com>
References: <201106221259.40135.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=fVlvpo5hSc5P5e3xqfzuMuoUi+Jfdb4k2oOAftDBpvg=;
        b=gZQoAUh/7SA32F9shJs86RW97C5vELOn0YL4oPitpqltG6nLyT1OUA/Srwr44F18Ak
         w++SLhonfOFwlV8rk4oKTb1YH4BeD1vXr24WIZCcNlmit3uKqaLqmamcOqDjBrRNvqsv
         7o9dKXxpgCopME8ydDiK4JHikX3qMbImYwBM8=
In-Reply-To: <201106221259.40135.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Oops,


On Wednesday 22 of June 2011 12:59:40 dexen wrote:
>  * remove all the snapshots with rmcp

should be:
 * remove all the checkpoints with rmcp=20


Regards,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

=46or example, if the first thing in the file is:
   <?kzy irefvba=3D"1.0" rapbqvat=3D"ebg13"?>
an XML parser will recognize that the document is stored in the traditi=
onal ROT13 encoding.

(( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
