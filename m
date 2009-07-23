From: havuz goz <dutdurudut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Regarding NILFS performance
Date: Thu, 23 Jul 2009 12:05:18 +0300
Message-ID: <447f427d0907230205r2913fef4l8d912c0b093a4904@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0760565367=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============0760565367==
Content-Type: multipart/alternative; boundary=001636c5a9bd604ced046f5bc902

--001636c5a9bd604ced046f5bc902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello there,
I apologize in advance if this e-mail is redundant. I'm not a developer, but
log-based filesystems intrigue me. I have seen some benchmarks (I think on a
linux-mag.com article), which didn't reflect the performance I had been
expecting.

My basic understanding of how NILFS operates is that it appends a file which
is to be committed to disk to the head of the log, eliminating,
theoretically, the need to carry out random writes. From this I extrapolate
, writes should be incredibly fast, since even budget ssds are capable of
burst-write speeds of 200 mb/s. What real-life factor exactly holds back
NILFS's speed?

What happens with huge files? Is it possible to commit the modifications
applied to a file as separate differential file, leaving the original file
intact? What about defragging? Does the garbage collection system move
rarely modified files out of the way?

I presume read performance is not the primary consideration in the
development of NILFS, since reads are cached and modern ssds are incredibly
fast at random reads anyway. Since the burst read performance of both hdds
and ssds is blazing fast, does it make sense to burst-read an entire cluster
of adjacent small files and pick the desired files in system memory? I
wouldn't mind if the unnecessary files were left in ram either, since modern
computers have vast unused ram space.

Thanks in advance.

--001636c5a9bd604ced046f5bc902
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello there,<div><br></div><div>I apologize in advance if this e-mail is re=
dundant. I&#39;m not a developer, but log-based filesystems intrigue me. I =
have seen some benchmarks (I think on a <a href=3D"http://linux-mag.com">li=
nux-mag.com</a> article), which didn&#39;t reflect the performance I had be=
en expecting.</div>
<div><br></div><div>My basic understanding of how NILFS operates is that it=
 appends a file which is to be committed to disk to the head of the log, el=
iminating, theoretically, the need to carry out random writes. From this I =
extrapolate , writes should be incredibly fast, since even budget ssds are =
capable of burst-write speeds of 200 mb/s. What real-life factor exactly ho=
lds back NILFS&#39;s speed?</div>
<div><br></div><div>What happens with huge files? Is it possible to commit =
the modifications applied to a file as separate differential file, leaving =
the original file intact? What about defragging? Does the garbage collectio=
n system move rarely modified files out of the way?</div>
<div><br></div><div>I presume read performance is not the primary considera=
tion in the development of NILFS, since reads are cached and modern ssds ar=
e incredibly fast at random reads anyway. Since the burst read performance =
of both hdds and ssds is blazing fast, does it make sense to burst-read an =
entire cluster of adjacent small files and pick the desired files in system=
 memory? I wouldn&#39;t mind if the unnecessary files were left in ram eith=
er, since modern computers have vast unused ram space.</div>
<div><br></div><div>Thanks in advance.</div>

--001636c5a9bd604ced046f5bc902--

--===============0760565367==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0760565367==--
