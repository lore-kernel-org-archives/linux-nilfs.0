From: Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 13/19] block: move blk_next_bio to bio.c
Date: Tue, 18 Jan 2022 22:10:17 +0000
Message-ID: <898045a2-19a4-15ba-a352-ce1767f17cac@nvidia.com>
References: <20220118071952.1243143-1-hch@lst.de>
 <20220118071952.1243143-14-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10TAAnZvOSR4S0y2NuqUH4W60yc9IevVM3hnAGv74bc=;
 b=FhXV9Xl012EiGpClBUVVB8qPdyvxDkKnr5exmZ2iEUFQt7zImZmW9VVJDXZcagdYqGYNJxzP0jHifQ5OSrksjNkg/czJQX91qU/TKVvDdpAYnYo+MuRHqVUGKixBRXKG8Y+c/j5H4VUkVjhvkRnjkTGV1/qDOPvYx2EmfMXppiGSNA7A/DXelI29lqc3sUzj4Cey6XJoHRVAvahqcV+GxQ6sQ8fdkJfakpeeti/rmQuUw+cMgCiaR+FtrhVQi8ebUUeYCgklDblHrRLRKhunNSV9HsJtOM2D/4ovfTSaNQ+DmnuRWYSHqIobASY3dXsnA+0JvbgIc2Q4q1ETfu58+w==
In-Reply-To: <20220118071952.1243143-14-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Content-ID: <B517DE78369F2A41BFFA7CE0A7153DC7-asWib9pRmPqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Md . Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau-Sxgqhf6Nn4Bhl2p70BpVqQ@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org" <ntfs3@l>

T24gMS8xNy8yMiAxMToxOSBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEtlZXAgYmxr
X25leHRfYmlvIG5leHQgdG8gdGhlIGNvcmUgYmlvIGluZnJhc3RydWN0dXJlLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQoNCg0KTG9va3MgZ29v
ZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoN
Cg0K
