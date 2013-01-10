From: Paul Fertser <fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: New experience with the odd problem starting nilfs_cleanerd due to
	an eMMC misbehaviour
Date: Thu, 10 Jan 2013 17:16:59 +0400
Message-ID: <20130110131659.GA29689@home.lan>
References: <20120126135203.GM2267@home.lan>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:date:from:to:subject:message-id:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7hisRtF+pcZuu/IglBpEStZo6TmqPeqYYHRFGvRtbsw=;
        b=WR7jqhN7gIagyCcGXVq1l5FYa0JTcIWCUpzYkb2DUVHbm/fv1t+GenpGGC73AMytur
         MgtPt5ED1fM3iaJCobJv4dsaZn/NpY2PUYmUZ7lhsM1wXKcfajLFp68aiJj3CduEzB8T
         cX+INd7XkclDQfX0AulCGl2OUIyEbxvL5xs0YjOMhqg3dQERS58QVIwdTE6m4g9SQs++
         lqTQmVTD8WlBwTW/Xmd+QDdcDLfzC7Zspo5DCVx7TN7/sHasFiI8oeqIWg11bLdGsPSW
         oWmvRhxp9qS+wQpS4d0V9vo/ZKbDpYUJUyD4rV0IIgjI/2AzIW3JZ4SgGVFW9XtTCW6u
         61pA==
Content-Disposition: inline
In-Reply-To: <20120126135203.GM2267-0MSThuzptbI@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I've reported this issue earlier and back then it "resolved itself"
after a power-cycle. The hardware in question is the same ac100
netbook with an internal 32GB eMMC.

On nilfs_cleanerd start i was consistently getting these messages:
[   46.122096] mmcblk0: error -110 transferring data, sector 26671630, nr 10, card status 0x200900
[   48.934623] mmcblk0: error -110 transferring data, sector 26671631, nr 9, card status 0x200900
(and similar output for two other sectors)

However, this time was different, several full power cycles didn't
help and the read was still failing and cleanerd refused to start.

So i resorted to brute force, trying to write to the sectors in
question. 512 and 2048 byte writes were failing with the same error
message, so i tried 4096 and it took about a second but succeeded:

dd if=/dev/zero of=/dev/mmcblk0 bs=4096 count=1 seek=3333953

Same has to be done with the other failing sector.

And only after that i was able to start nilfs_cleanerd and my system
seems to be running fine again.

If it happened with e.g. ext4, i would be unable to read a certain
file and after several attempts would simply delete it and the blocks
in question would get overwritten eventually without any impact for
the system usability. However, with nilfs had i not figured out the
"dd" trick i would have to overwrite the whole filesystem (and in fact
that's the main and only partition on my netbook). The described mmc
card behaviour (i.e. remapping bad blocks only on write attempts)
seems to be kind of reasonable and i would expect the same problem to
happen with someone else one day.

HTH
-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
