From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 08/31] block: share code between disk_check_media_change
 and disk_force_media_change
Date: Wed, 7 Jun 2023 15:18:48 +0200
Message-ID: <82a4143b-f800-09b9-98f2-6cda791877da@suse.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-9-hch@lst.de>
 <30183892-dce6-6946-2f7a-1bc693a657a2@suse.de>
 <20230607122131.GB14579@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686143929; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Udh/Vtqb23Sw8g+BkC8HMo4Q973SRGdJCkPyY7KWLNs=;
        b=AG50lh6cNYbwFkDgaT6ESY/6kXvuXC7sDHKKcw8pqjJuajtZFb5iJMjU+bUHLK8tmhUW/e
        3ggaoVJAuSiXjFOzMcU4WcpaNZCGv6jm+/3d19A6Snff4yAvXS0PckIuYdEhm38+y+iNCH
        we5Xow+88Kal0HjgD/hcxHzey97Vt2s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686143929;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Udh/Vtqb23Sw8g+BkC8HMo4Q973SRGdJCkPyY7KWLNs=;
        b=yrTu3ioEdQb/jvgg+opgbJOkJi/9oj9MdczoHd3QPBmppQ7hl9wTr/b/RUlZdWJ4DBVXYd
        uqhxaF5C7dZDCxAA==
Content-Language: en-US
In-Reply-To: <20230607122131.GB14579-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Phillip Potter <phil-j1cSt2lHDeZzjhtm8Ag3mw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvm

On 6/7/23 14:21, Christoph Hellwig wrote:
> On Wed, Jun 07, 2023 at 02:19:00PM +0200, Hannes Reinecke wrote:
>>> -	return true;
>>> +	return __disk_check_media_change(disk,
>>> +			disk_clear_events(disk, DISK_EVENT_MEDIA_CHANGE |
>>> +						DISK_EVENT_EJECT_REQUEST));
>>
>> Can you move the call to disk_clear_events() out of the call to
>> __disk_check_media_change()?
>> I find this pattern hard to read.
> 
> I suspect you've not done enough functional programming in your youth :)

That's why I said 'I find'; purely personal preference.
If you're happy with:

Reviewed-by: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>

Cheers,

Hannes
(In my youth? One is tempted to quote Falco: "If you remember the '90s 
you haven't experienced them...")

