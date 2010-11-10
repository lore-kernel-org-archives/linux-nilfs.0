From: "Jason J. W. Williams" <jasonjwwilliams-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re-capturing space
Date: Wed, 10 Nov 2010 12:10:25 -0700
Message-ID: <AANLkTi=+FiC=y2jpV-rJmgxdsMEdVBkk9E2_3SZGed3L@mail.gmail.com>
References: <AANLkTi=6k2_v4Ga+4V8EQEsGQ5oNTn_wnc=bbdB94k27@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:received:in-reply-to
         :references:date:message-id:subject:from:to:content-type;
        bh=ceQPqJvBN/XMlSCQGi2H2vzkh0RcvhEUl6F3pN+O9OM=;
        b=Op9aVh3eXrF+i8Svqt8D185nt0X70TJvsA1Wnh0JFUvOvKYORCVCxT79mqKbkqcDzH
         NGF+3DyjVgBiPgEDgDhrY0Riturk9Bs+j/Jz11qz6QPripGpRcFOnIlTdYPJfy5Qe+eV
         O4eFKHjoGQro/QmUeWT92wC6CdVRBRpE2d6LI=
In-Reply-To: <AANLkTi=6k2_v4Ga+4V8EQEsGQ5oNTn_wnc=bbdB94k27-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,
I'm looking at NILFS as a possible alternative to BTRFS for our move
off of ZFS. Looking at the description of how NILFS works, it seems
like it's one big log. New records go on the front. My question is how
does space eventually get recaptured when you delete files? Does the
log get rewritten/compacted regularly?

-J
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
