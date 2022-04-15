From: Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 13/27] block: add a bdev_fua helper
Date: Fri, 15 Apr 2022 05:42:07 +0000
Message-ID: <77dedfc7-d5af-4d87-0383-613b80139850@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-14-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXmWoxiNrFUT36KRaCWH5ftRvcuoLnY+vq0rmT1Kt9U=;
 b=PjcfOcmcIW+IJ+Rx7sLUBgkGMqL5A9o8uphx3jDX0X3PWGeQ7n8JJwtjzF4wxaDknIExHlAPQjAebMZY/u+ZU5YXZqony9jVj93r9e42VIOUwZtZOUhVOKYzuPQ418L2D9YinV5P3ASM3hpk+Z8l1gtLXh/oKAgJEPl0rxL6fjq4jhUXXVow5xQzmMlj45FbdPWI+THaSSV30hXXb4Z3aPWoVQxkZlwvOPVOWmMxQecPzPnSIjNvA0awydisQaYqmiVEPzY+LECJ09AJUKiN+T2VQ+aQxh+vAkV4lFt8kJAQHYNWnsYXDOKMmAOABtDsDaUImG5BHHxkuAKfIqczjg==
In-Reply-To: <20220415045258.199825-14-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Content-ID: <DF997BF112FF594981505DC1D908FBEE-asWib9pRmPqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, "nbd-2H2hN8V1XRtuHlm7Suoebg@public.gmane.org" <nbd-2H2hN8V1XRtuHlm7Suoebg@public.gmane.org>, "ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org" <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBhIGhlbHBl
ciB0byBjaGVjayB0aGUgRlVBIGZsYWcgYmFzZWQgb24gdGhlIGJsb2NrX2RldmljZSBpbnN0ZWFk
IG9mDQo+IGhhdmluZyB0byBwb2tlIGludG8gdGhlIGJsb2NrIGxheWVyIGludGVybmFsIHJlcXVl
c3RfcXVldWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxz
dC5kZT4NCj4gUmV2aWV3ZWQtYnk6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2Vu
QG9yYWNsZS5jb20+DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vs
a2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0K
