From: Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 18/19] block: pass a block_device and opf to bio_init
Date: Tue, 18 Jan 2022 22:15:35 +0000
Message-ID: <43d7b708-317c-4dd2-2de3-dc1755c4f835@nvidia.com>
References: <20220118071952.1243143-1-hch@lst.de>
 <20220118071952.1243143-19-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+NRM5dbEf/ywcja/WF6bJ0xMCvzgQeV/oka59TCa2E=;
 b=ihulHJIy+zKFG2NtDqIiiB+lxa5r89dSuqiqrFbL/+FEFrqNYbYXH956G0GKkcA3EccGGAJ3CoODZUNR/fDyjUZtM38BKTY4DNU5xRfC19rcraeN9BRGUsGR4I3DqIwZoV6YPsaBSOAovKaqeLyPbxk7kCkk4c/iQoA3gBvoePAPaKkbfNeU66zAcb6V0GSa+j1iR6/vtwUx0xWcJuPIGv5i2wMhHRf7rVtEB68Z5yj7RSOinVg2zympniAoLpDRvwtV+B/s8V+V2lJ59lJv7F+SAyiRmwjz3QMC7CqB5yGdqmGHXdBgJdTzeFk3Zy5jZmS9Fp0LpH7KY4Xx2DtXhQ==
In-Reply-To: <20220118071952.1243143-19-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Content-ID: <68497571FD293D40AE092A66BF25DCEA-asWib9pRmPqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Md . Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau-Sxgqhf6Nn4Bhl2p70BpVqQ@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org" <ntfs3@l>

T24gMS8xNy8yMiAxMToxOSBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFBhc3MgdGhl
IGJsb2NrX2RldmljZSB0aGF0IHdlIHBsYW4gdG8gdXNlIHRoaXMgYmlvIGZvciBhbmQgdGhlDQo+
IG9wZXJhdGlvbiB0byBiaW9faW5pdCB0byBvcHRpbWl6ZSB0aGUgYXNzaWdtZW50LiAgQSBOVUxM
IGJsb2NrX2RldmljZQ0KJ3MvYXNzaWdtZW50L2Fzc2lnbm1lbnQnID8NCj4gY2FuIGJlIHBhc3Nl
ZCwgYm90aCBmb3IgdGhlIHBhc3N0aHJvdWdoIGNhc2Ugb24gYSByYXcgcmVxdWVzdF9xdWV1ZSBh
bmQNCj4gdG8gdGVtcG9yYXJpbHkgYXZvaWQgcmVmYWN0b3Jpbmcgc29tZSBuYXN0eSBjb2RlLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0t
LQ0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hA
bnZpZGlhLmNvbT4NCg0K
