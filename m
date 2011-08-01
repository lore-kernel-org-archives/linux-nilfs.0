From: David Sariel <davidsa.openu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: atime
Date: Mon, 01 Aug 2011 08:53:33 +0300
Message-ID: <4E363F5D.7060302@gmail.com>
References: <BLU152-W53BCFBB71148893681289CE350@phx.gbl>	<BLU152-W1990E7DAA23E5566FC3925CE350@phx.gbl>	<BLU152-W567E135957B79607CC415ECE350@phx.gbl> <20110728.102536.53123850.ryusuke@osrg.net>
Reply-To: davidsa-BMswWb+h+80+JF/nGntIXQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=0eHjLdBsQeNKR3LePHFPEQ3xsnELQANXyMhPDcrlCsc=;
        b=Qsr4CEJCI+Qnr77Q+/BYkIGnoleLEyEnYJ2Lx9c8mcSNtEQQPde1CpZ0ZQVk/UxM3V
         XqBMf2JFgwHG2joYQ6jL81+0TpHHqFTljapAoa+I7NkXq0mIGb0qXjEhY0Eu/Ty6ygKh
         AqR7eAzNML5y9QWrjXEHpDFKOIg1PQEdOml+k=
In-Reply-To: <20110728.102536.53123850.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: 
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi
What was the purpose of reserving the inode for atime file (nilfs2_fs.h)
#define NILFS_ATIME_INO        7    /* Atime file (reserved) */
Correct me if I'm wrong, but it seems to me that updating atime on the disk
result in creating more chekpoints. So spesial file in predetermined 
place can store
atime of all files in the system and spare the need of checkpointings of 
many segments.
Also can you please share your thoughts about the atime implementation 
on nilfs?
Thank you
David



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
