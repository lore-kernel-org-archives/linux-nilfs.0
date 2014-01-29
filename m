From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [static superblock discussion] Does nilfs2 do any in-place writes?
Date: Wed, 29 Jan 2014 19:18:15 +0100
Message-ID: <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com>
References: <1389787304.3913.28.camel@slavad-ubuntu>
	<20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
	<1389866912.2565.44.camel@slavad-ubuntu>
	<20140118.090008.194171715.konishi.ryusuke@lab.ntt.co.jp>
	<1390901114.2942.11.camel@slavad-ubuntu-12.04>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=XgRIlg8FWArc+0x+b6Z3Jnk7/BMJIAyEPMJkyIgrpqk=;
        b=h0msNg+9fGSwvr3UZqF5dXfwQQ8C4B9018kMHE6JPKVOmbcTYIL5K2O2egsHq1gyfg
         i/khmi8tSmnhjh4wJDo7niMQy4veGaNHhJpa5EntE3e9qRupwX0CiL6pZqNUCtCEHoIe
         BlgB9KPDj/feveKr/fnTrBDf0s5Ju8CYRN8FoIBv1CXENWJyoMByiSowFEcuLC4/BMOE
         nH73DbevVQzyct2vb5yNPHhwTEquWhzXYp/uY+F2AZLKc3suVV0+oak1SVcRvPVBN2at
         Ltpiyx7wrniIq53P7jX71J/EycYjOez30hkQIrpJUHbTttzCSv5fks74S5KmQwQ4Pj8v
         gKRw==
In-Reply-To: <1390901114.2942.11.camel-dzAnj6fV1RxGeWtTaGDT1UEK6ufn8VP3@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

Just to make sure I understand your approach: You reserve two areas (a
few mb in size) which are dedicated to hold only super-root data and
this data is written at the same frequency as the current superblock?
If so, this most likely won't improve the situation for flash media
with weak FTL - as those writes will still be concentrated around a
few erase blocks. For devices with powerful FTL such as modern SSDs,
updating the superblock periodically doesn't pose a real problem.

I am still somewhat favour an optional simple linear-scan.
Would it be possible to check at mount-time whether the volume was
cleanly unmounted and otherwise perform a linear scan?
So when I mount the volume with o=no_superblock_update a flag is set
in the superblock, which is reset on a clean volume unmount after the
most recent segment has been stored in the superblock.
When at mount-time the flag is still set, nilfs knows a scan is
required as the segment in the superblock is not up-to-date.

Thanks & regards, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
