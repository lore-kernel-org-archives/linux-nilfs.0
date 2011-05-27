From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Ability to discard all changes after a point in time?
Date: Fri, 27 May 2011 08:28:28 +0200
Message-ID: <201105270828.32843.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=T9yLqrNNK/sj0hpd7MWz+9x3sL4MRMsDgsBAGwbRXl4=;
        b=jBjnoiz3P//UL3bFOYnBZClY1ih1oXVx7ODut5Ktd1j2UO5uOZujdRqGn7v2jMN3Iv
         NXh4MH2ZXlCtLIfFaQMdGIPZ3pypCVQnznSIR7A5nxAftY132C48GV4M3V3jJpzl6EQH
         oRZn5Cf9vx8F4x6h7d+tOlNr99B2oW6yht6vk=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,


recently I was searching for a way to discard all changes after a certain 
point in time -- that is, to rollback filesystem state to a particular 
checkpoint. I couldn't find a way, is there any?

If not, I'd like to request such functionality. Preferrably selectable at 
mount time, via an argument to mount (or the `rootflags' kernel parameter).

Something along the lines `rollbackto=<checkpoint-number>'. 

The desired effect is to set the indicated checkpoint as the latest one, so all 
subsequent changes to filesystem are discarded.


What are your thoughts on that?


Regards,
-- 
dexen deVries

``One can't proceed from the informal to the formal by formal means.''
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
