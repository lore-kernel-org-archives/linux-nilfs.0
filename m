From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Nilfs features
Date: Tue, 02 Jun 2009 18:23:37 +0900 (JST)
Message-ID: <20090602.182337.68211692.ryusuke@osrg.net>
References: <20090526.082051.100027806.ryusuke@osrg.net>
	<20090601.012057.21016829.ryusuke@osrg.net>
	<4A24E100.8040204@0bits.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A24E100.8040204-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org>
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
To: dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Tue, 02 Jun 2009 12:21:20 +0400, Dave wrote:
> On 05/31/09 20:20, Ryusuke Konishi wrote:
> > Hi,
> > On Tue, 26 May 2009 08:20:51 +0900 (JST), Ryusuke Konishi wrote:
> >> Hi,
> >> On Mon, 25 May 2009 13:46:14 +0400, Dave wrote:
> >>> In addition to this there doesn't seem to be a way to delete a range of 
> >>> checkpoints. When i did my restore from my archive, i generated 700+ 
> >>> useless checkpoints which i had to delete one by one (in a script). It 
> >>> would be nice to have a 'rmcp 1-100' or 'rmcp -100' or 'rmcp 100-' to 
> >>> delete a checkpoint range, a start to end.
> >> Okay, I'll take in this in some form.
> > 
> > For the moment, I've added this feature and pushed it into the git
> > tree.
> > 
> > (Instead of '1-100', '-100', or '10..', I took notation like '1..100',
> >  '..100', or '10..' respectively, according to the git tool)
> > 
> > If you would like to try it soon, please see
> > 
> >  http://www.nilfs.org/git/
> > 
> > for download/build information.
> > 
> > I'll include it in the next release of the utility package.
> > 
> 
> Hi Ryusuke,
> 
> I've tried this and it seems to work perfectly. Thanks for the quick 
> feature addition.
> 
> It seems that i still have to wait for cleanerd to kick in to reclaim 
> the space even though i clearly cannot get to a checkpoint i've just 
> deleted. I believe we should reclaim immediately (but perhaps this is 
> harder to implement)...
 
Yes, checkpoint removal by rmcp does not mean reclamation; operation
of the cleanerd is necessary to that end.

Well, I thought the (plain) checkpoints are equivalent to deleted
ones.  But the checkpoint removal makes a differece in that deleted
checkpoints become unprotected by the protection period.

Hmm, indeed we need some change on the cleanerd.
At least the cleanerd should be notified about the removal and
revaluate the need of reclamation.

Thanks you for feedback.


Regards,
Ryusuke Konishi

 
> bash-3.2# df -h .
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb2              39G  9.0G   28G  25% /home
> bash-3.2# cp /shared/1gb .
> bash-3.2# df -h .
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb2              39G   10G   27G  28% /home
> bash-3.2# lscp | tail
>                155133  2009-06-02 12:12:27   cp    i       6662     253255
>                155134  2009-06-02 12:12:29   cp    -         35     253255
>                155135  2009-06-02 12:12:32   cp    i       6622     253255
>                155136  2009-06-02 12:12:37   cp    i       6587     253255
>                155137  2009-06-02 12:12:42   cp    i       6654     253255
>                155138  2009-06-02 12:12:47   cp    i       6744     253255
>                155139  2009-06-02 12:12:52   cp    i       6524     253255
>                155140  2009-06-02 12:12:57   cp    i       6762     253255
>                155141  2009-06-02 12:13:02   cp    i       6670     253255
>                155142  2009-06-02 12:13:07   cp    -       6748     253255
> bash-3.2# rm 1gb
> bash-3.2# df -h .
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb2              39G   10G   27G  28% /home
> bash-3.2# lscp|tail
>                155151  2009-06-02 12:13:29   cp    -         35     253188
>                155152  2009-06-02 12:13:35   cp    -        237     253229
>                155153  2009-06-02 12:13:37   cp    -       6334     253238
>                155154  2009-06-02 12:13:42   cp    -       8380     253255
>                155155  2009-06-02 12:13:47   cp    i       7987     253255
>                155156  2009-06-02 12:13:52   cp    i       3743     253255
>                155157  2009-06-02 12:13:57   cp    i       8092     253255
>                155158  2009-06-02 12:14:02   cp    i       7991     253255
>                155159  2009-06-02 12:14:07   cp    i       7986     253255
>                155160  2009-06-02 12:14:12   cp    -       9129     253254
> bash-3.2# rmcp ..155160
> bash-3.2# lscp|tail
>                   CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
>                155161  2009-06-02 12:14:17   cp    i       6839     253254
>                155162  2009-06-02 12:14:22   cp    i       7012     253254
>                155163  2009-06-02 12:14:27   cp    -       6886     253255
>                155164  2009-06-02 12:14:29   cp    -         51     253254
>                155165  2009-06-02 12:14:32   cp    i       6737     253254
>                155166  2009-06-02 12:14:37   cp    i       2618     253254
> bash-3.2# df -h .
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb2              39G   10G   27G  28% /home
> 
> 
> 
> much appreciated.
> Dave
