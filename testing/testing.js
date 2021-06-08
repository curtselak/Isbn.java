const jsons = require('line-reader');
const isbns = require('fs');
let infile = process.argv[2];
let outfile = infile.substring(0,infile.length - 12) + 'testing' + 
	infile.substring(infile.length - 8).substring(0,4);
jsons.eachLine(infile, function (line) {
		let json = JSON.parse(line);
		isbns.appendFileSync(outfile,json['Qualified registrant element']);
		isbns.appendFileSync(outfile,json['PUBLICATION_ELEMENT']);
		isbns.appendFileSync(outfile,json['CHECK_DIGIT']);
		isbns.appendFileSync(outfile,'\n');
});