From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: read checksum verification
Date: Wed, 12 Jul 2023 20:32:13 +0200
Message-ID: <174f995c-e794-74c4-24d6-52451f3f3f28@prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I recently had a bad experience with NILFS (not the fault of NILFS).

I used NILFS over ISCSI. I had random block corruption during one week, 
silently destroying data until NILFS finally crashed. First of all, I 
thought about a NILFS bug, so I created a BTRFS volume and restored the 
backup from one week earlier to it. After minutes, the BTRFS volume gave 
checksum errors, so the culrprit was found, the ISCSI server. For now I 
will use BTRFS on my ISCSI volumes to not have the same situation again 
even if I would prefer using NILFS due to continuous checkpointing. If I 
can remember well, NILFS creates checksums on block writes. It would 
really be a good addition to verify these checksums on read, so 
corruption of this type would be noticed within minutes instead of days 
or possible never if rare enough. I think it has been mentioned earlier 
that NILFS checksum are not suitable for file verification but only for 
block verification. I think the most important is to know that something 
nasty is going on, even if the details aren't known, so I think it would 
be a good addition the have some sort of data checksum verification on 
read in NILFS.

Bye,

David Arendt

