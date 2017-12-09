From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Date: Sat, 09 Dec 2017 09:00:18 -0800
Message-ID: <1512838818.26342.7.camel@perches.com>
References: <fd7130d7-9066-524e-1053-a61eeb27cb36@lge.com>
         <Pine.LNX.4.44L0.1712081228430.1371-100000@iolanthe.rowland.org>
         <20171208223654.GP5858@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171208223654.GP5858@dastard>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-Hm3cg6mZ9cc@public.gmane.org

On Sat, 2017-12-09 at 09:36 +1100, Dave Chinner wrote:
> 	1. Using lockdep_set_novalidate_class() for anything other
> 	than device->mutex will throw checkpatch warnings. Nice. (*)
[]
> (*) checkpatch.pl is considered mostly harmful round here, too,
> but that's another rant....

How so?

> (**) the frequent occurrence of "core code/devs aren't held to the
> same rules/standard as everyone else" is another rant I have stored
> up for a rainy day.

Yeah.  I wouldn't mind reading that one...

Rainy season is starting right about now here too.

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
