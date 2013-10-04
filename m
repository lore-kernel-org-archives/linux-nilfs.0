From: Yevhen Kyriukha <kirgene-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Revert system state to snapshot
Date: Fri, 4 Oct 2013 15:28:14 +0300
Message-ID: <CADV-EXEQUt9uP1xeDuMOQ-Qx-ghrvPwdMZL3a8G65e9ndiyeZw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=+rzWfWzqyi7amO9tLaxCaDg27UIEt/eP69Pl0Ex3Lhc=;
        b=sVxtsMi/3CJw+NHbcYoViXPB7MXLDNVD7vj7StRyrlhiQ7TbNZ050XfjiYu02/lAeE
         JfSch+j0UVICCmOyyDerH+tb7VVGvDIsucOamimFrrgRflTf9puj2wjzuPbXmh9tQxm2
         std/X7wFHfArstIT70tFK0MVCud38G0xG/BgnAywQbIPSBcIHLvyV66yFwaH+T18uICe
         VSti45d6WNoGkGvH7Nm7QhgShQBQW9qBorHIqMai3Q2u1/yC3w8fzDDL1sO6WUeUQkWL
         whsZVjngbajIltrBJL2zb8iRN/7LFW2iH9QpQlW+Om+iEkonNqwn9OIngiH5x9vuvzKa
         RVKQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi!

I'm wondering how can revert to snapshot by mounting file system as
writable in this state.

I know that NILFS2 currently doesn't support this feature, but I think
that implementation of such functionality is highly desirable.
Is there any date or estimates when this feature will be implemented?

Best regards,
Yevhen
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
