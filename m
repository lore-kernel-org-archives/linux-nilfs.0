From: Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] block: pass a block_device and opf to blk_next_bio
Date: Tue, 18 Jan 2022 22:11:06 +0000
Message-ID: <245eaa0a-0796-0227-4abf-d1b78953557e@nvidia.com>
References: <20220118071952.1243143-1-hch@lst.de>
 <20220118071952.1243143-15-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7W6lHAj2LoZRdhgNrVK68jx3YXevYUKyU9h4DHJ8Ns=;
 b=Smu0nY/ooUtddj+lq9zl50nZjjD5oZNrnOdKX8SdwuTOOiHb+aUmU41D+R90jUgwZ+Xwo0dJpfzObi/exMhlyDhLtPobJdTjGwdExzuRzHVj2NmtKKBSfdJKmjIaDbX4S0YBRjHGth64KFjszs8X3jV6RE3ZH4n1E3cKZDKCsQdCoytOzaV/lDb2mrpmi+FQhXk1kgOf7Y3xwkh9iAPQdSPj1ODdFSksJyrlv85Ixw5tbwD/acHb7WGNRgz6B8KAUCE2tKcsnEBifFY85rqoAyCJIdIPnXHY3pRqO3wnZV3O9JhZAZ1FCFx5QlFMgbkm5Y4+ie2rs0wE7pvFqDIkJQ==
In-Reply-To: <20220118071952.1243143-15-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Content-ID: <72D9A4819752A44299892B2C633A7AB8-asWib9pRmPqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Md . Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau-Sxgqhf6Nn4Bhl2p70BpVqQ@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org" <ntfs3@l>

T24gMS8xNy8yMiAxMToxOSBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFsbCBjYWxs
ZXJzIG5lZWQgdG8gc2V0IHRoZSBibG9ja19kZXZpY2UgYW5kIG9wZXJhdGlvbiwgc28gbGlmdCB0
aGF0IGludG8NCj4gdGhlIGNvbW1vbiBjb2RlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0
b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KDQpJIHNlbnQgb3V0IHRoZSBleGFjdCBw
YXRjaCBmb3IgdGhpcyBvbmUsIGFueXdheXMgbG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENo
YWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCg==
