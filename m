From: dE <de.techno-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_clean_segments: segment construction failed. (err=-2)
Date: Thu, 26 Jun 2014 11:30:20 +0530
Message-ID: <53ABB6F4.5050508@gmail.com>
References: <53ABA8F3.3010606@gmail.com> <A863805F-8398-42B1-9BEA-35D4425E2404@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        bh=NyA7vpdx1flQjY8fYO0Kl1GEcfQfkGbmPdUM/vkCdlg=;
        b=KALBnjHsF8P2+bvrDnVoyiBRzJG5cy9comwpdrrnBcI2+U/UTSzeMGdSA666ezah5z
         BqtATGTcA8rUek8AZLIGtBSuAhNNyuECZI8Pgp6D2eDKJXXP+/pOChwtRfcaoNU/04Q4
         rtpK7cC8pP+Pf9kvPjyQCp3bAQg9e99pqKf7YEeYjPkuC4ryhlv/jsZQT2ifJqQy7AFB
         03CxLSwMYuc9EIdI3itXLQvrrO//W10vbQRR8C78Fvow+1rPCo2XfLn8YSuaMiB0PUp9
         +A68bEtcpsHzMsoWvkQEbxVxTm6c8sOFbJxI5A2FsT38Mn+0JPoRSoB2Vhpufn1Q074I
         P7yA==
In-Reply-To: <A863805F-8398-42B1-9BEA-35D4425E2404-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 06/26/14 11:05, Vyacheslav Dubeyko wrote:
> On Jun 26, 2014, at 9:00 AM, dE wrote:
>
>> Hi!
>>
>> I'm using nilfs on thumb drives to sync Bitcoin wallets and it's forks.
>>
>> Sometimes, when I quit the bitcoin-qt application, this is what happens (in dmesg)
>>
>> [159141.505498] nilfs_btree_propagate: key = 10, level == 0
>> [159141.715622] nilfs_btree_propagate: key = 10, level == 0
>> [159141.716134] NILFS warning (device dm-0): nilfs_clean_segments: segment construction failed. (err=-2)
>> [159146.715145] nilfs_btree_propagate: key = 10, level == 0
>> [159146.715152] NILFS warning (device dm-0): nilfs_clean_segments: segment construction failed. (err=-2)
>> [159151.715018] nilfs_btree_propagate: key = 10, level == 0
>> [159151.715026] NILFS warning (device dm-0): nilfs_clean_segments: segment construction failed. (err=-2)
>> [159156.714892] nilfs_btree_propagate: key = 10, level == 0
>> ...
>> ...
>> ...
>> [160276.691089] nilfs_btree_propagate: key = 10, level == 0
>> [160276.691096] NILFS warning (device dm-0): nilfs_clean_segments: segment construction failed. (err=-2)
>> [160281.690959] nilfs_btree_propagate: key = 10, level == 0
>> [160281.690967] NILFS warning (device dm-0): nilfs_clean_segments: segment construction failed. (err=-2)
>>
> What kernel version do you use?
> What garbage collection policy do you use?
> Could you share superblock content (nilfs-tune -l)?
>
>> I can still access the thumbdrive and it's contents. In the mean time many processes remain at D state and I have to force restart.
>>
> So, could you describe clear way of the issue reproducing on my side?
>
> Thanks,
> Vyacheslav Dubeyko.
>

I'm using 3.14.4. I thought there was only 1 selection policy, so it's 
set to timestamp.

nilfs-tune -l /dev/bitcoin/bitcoin
nilfs-tune 2.1.6
Filesystem volume name:   test
Filesystem UUID:          9e1064e0-4ce8-4831-93c0-758b46118884
Filesystem magic number:  0x3434
Filesystem revision #:    2.0
Filesystem features:      (none)
Filesystem state:         invalid or mounted
Filesystem OS type:       Linux
Block size:               1024
Filesystem created:       Sun Jun 22 15:31:18 2014
Last mount time:          Thu Jun 26 11:26:50 2014
Last write time:          Thu Jun 26 11:27:23 2014
Mount count:              5
Maximum mount count:      50
Reserve blocks uid:       0 (user root)
Reserve blocks gid:       0 (group root)
First inode:              11
Inode size:               128
DAT entry size:           32
Checkpoint size:          192
Segment usage size:       16
Number of segments:       11375
Device size:              23857201152
First data block:         4
# of blocks per segment:  2048
Reserved segments %:      1
Last checkpoint #:        208680
Last block address:       13015040
Last sequence #:          525413
Free blocks count:        3723264
Commit interval:          0
# of blks to create seg:  0
CRC seed:                 0x1b525ab2
CRC check sum:            0xcede51d1
CRC check data size:      0x00000118

I suspect this has to do with the segment size. So I've re-formatted a 
device with the default segment size. Let's see if I can reproduce it now.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
