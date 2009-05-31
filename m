From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Nilfs features
Date: Mon, 01 Jun 2009 01:20:57 +0900 (JST)
Message-ID: <20090601.012057.21016829.ryusuke@osrg.net>
References: <4A1A68E6.50905@0bits.com>
	<20090526.082051.100027806.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090526.082051.100027806.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org
Cc: =?iso-8859-1?Q?J=E9r=F4me?= Poulin <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi,
On Tue, 26 May 2009 08:20:51 +0900 (JST), Ryusuke Konishi wrote:
> Hi,
> On Mon, 25 May 2009 13:46:14 +0400, Dave wrote:
> > In addition to this there doesn't seem to be a way to delete a range of 
> > checkpoints. When i did my restore from my archive, i generated 700+ 
> > useless checkpoints which i had to delete one by one (in a script). It 
> > would be nice to have a 'rmcp 1-100' or 'rmcp -100' or 'rmcp 100-' to 
> > delete a checkpoint range, a start to end.
> 
> Okay, I'll take in this in some form.

For the moment, I've added this feature and pushed it into the git
tree.

(Instead of '1-100', '-100', or '10..', I took notation like '1..100',
 '..100', or '10..' respectively, according to the git tool)

If you would like to try it soon, please see

 http://www.nilfs.org/git/

for download/build information.

I'll include it in the next release of the utility package.

Cheers,
Ryusuke Konishi
