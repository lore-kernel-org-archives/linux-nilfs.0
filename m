From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleanerd
Date: Mon, 19 Oct 2009 11:07:27 +0900
Message-ID: <c4a7c9420910181907y4d8d615fp831e3b518b907205@mail.gmail.com>
References: <ee5afd760910101518u4a85fd0fn6e5539a327b2a876@mail.gmail.com>
	<20091011.122911.131278678.ryusuke@osrg.net>
	<ee5afd760910102232o5f17c50cxb5024f6f76ecbcf5@mail.gmail.com>
	<20091011.154916.07997858.ryusuke@osrg.net>
	<ee5afd760910171347x4ad27199ka59d0e76f3271050@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <ee5afd760910171347x4ad27199ka59d0e76f3271050-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi,
2009/10/18 Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Sun, Oct 11, 2009 at 8:49 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
>>
>> According to the log, the error was repeatedly detected in a retry
>> loop in the nilfs_clean_segments kernel function which cleanerd calls
>> via ioctl. =A0The err=3D-28 means ENOSPC (no space left on the device).
>>
>> Yeah, if cleanerd falls into this state, it cannot handle any signals.
>> And, it doesn't return to userspace until the error is removed.
>>
>> As you are pointing out, I wonder why this error is generated on the
>> device having enough free space.
>>
>> I'll attach a patch to identify which function returns ENOSPC. =A0Could
>> you try the patch ?
>
> Hallo,
> I have done the patch. The output, with debug switched on, is in the
> attached file.
>
> I have done some more analizing. Everything that looks helpful is included
> in the file as wel.
>
> I hope it is useful
>
> Regards
>
> Jan de Kruyf.
>
> This day the Lord creates,
> so let us celebrate with joy!

Thank you for the detail report and your cooperation!

The log shows that GC got trapped due to real disk full on the /var directo=
ry.

Although the following lssu output shows there is one free segment, it's not
writable because the log to be written in the segment needs to know another
segment which comes next.

                 434  2009-09-26 12:31:31  -d-        2048
                 435  2009-09-28 20:42:54  ad-        2038
                 436  ---------- --:--:--  ad-           0
                 437  2009-09-25 16:25:30  -d-        2048

The problem is why this stuck situation happened.

If you have ever run an older version of nilfs (v2.0.13 or prior) for
the partition,
it may arise from erroneous metadata written by the old version.

Otherwise, the logic to predict disk full condition likely has some issue.

If you can reformat the partition, please try "-m" option of mkfs.nilfs2.
With the option, you can increase the number of segment reserved for
garbage collection.

By default, 5 percent of segments are reserved.
If the same problem happens for a higher ratio (e.g. 20% or so),
some kind of leakage seems to be in the disk full determination.

With regards,
Ryusuke Konishi
